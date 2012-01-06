/*
 * wifiloader
 * 
 * Finds the hardware's MAC address & sets up nvram.txt accordingly
 *
 * Reverse engineered from the ASUS binary by:
 *   Paul Burton <paulburton89@gmail.com>
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <cutils/properties.h>
#include <private/android_filesystem_config.h>

#define VMISC_PATH "/sys/devices/platform/ventana_misc"

#define WIFI_VENDOR_MURATA 0
#define WIFI_VENDOR_AZW    1

int get_wifi_vendor(void)
{
    FILE *file;
    char buf[16];
    int ventana_hw;

    file = fopen(VMISC_PATH "/ventana_hw", "r");
    if (!file) {
        fprintf(stderr, "Failed to open ventana_hw\n");
        return -1;
    }

    fscanf(file, "%s", buf);
    fclose(file);

    ventana_hw = strtol(buf, NULL, 0x10);
    return (ventana_hw >> 5) & 0x1;
}

int copy_nvram(const char *infilename, const char *mac)
{
    int ret = -1;
    FILE *infile, *outfile;
    char buf[100];

    const char *outfilename = "/data/misc/wifi/nvram.txt";

    infile = fopen(infilename, "r");
    if (!infile) {
        fprintf(stderr, "Failed to open %s\n", infilename);
        goto out;
    }

    outfile = fopen(outfilename, "w");
    if (!outfile) {
        fprintf(stderr, "Failed to open %s\n", outfilename);
        goto out_close_infile;
    }

    while (fgets(buf, sizeof(buf), infile))
        fputs(buf, outfile);

    if (ferror(infile)) {
        fprintf(stderr, "Failed to read %s\n", infilename);
        goto out_close_outfile;
    }

    fprintf(outfile, "\nmacaddr=%s", mac);
    fprintf(outfile, "\nnvram_override=1\n");

    if (chmod(outfilename, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH) ||
        chown(outfilename, AID_SYSTEM, AID_WIFI)) {
        fprintf(stderr, "Failed to change permissions of %s\n", outfilename);
        goto out_close_outfile;
    }

    ret = 0;
out_close_outfile:
    fclose(outfile);
out_close_infile:
    fclose(infile);
out:
    return ret;
}

int get_mac_from_mmc(char *mac)
{
    int ret;
    FILE *macfile;
    char buf[18+1];

    const char *mountdev = "/dev/block/mmcblk0p5";
    const char *mountpoint = "/data/mac";
    const char *macfilename = "/data/mac/wifi_mac";

    ret = mkdir(mountpoint, 0755);
    if (ret) {
        fprintf(stderr, "Failed to mkdir %s\n", mountpoint);
        goto out;
    }

    ret = mount(mountdev, mountpoint, "vfat", 0, NULL);
    if (ret) {
        fprintf(stderr, "Failed to mount %s\n", mountdev);
        goto out_rmmountpoint;
    }

    ret = -1;
    macfile = fopen(macfilename, "r");
    if (!macfile) {
        fprintf(stderr, "Failed to open %s\n", macfilename);
        goto out_unmount;
    }

    if (fscanf(macfile, "%18s", buf) != 1) {
        fprintf(stderr, "Failed to read %s\n", macfilename);
        goto out_closemacfile;
    }

    if ((strlen(buf) != 17) || (buf[2] != ':') || (buf[5] != ':') ||
        (buf[8] != ':') | (buf[11] != ':') || (buf[14] != ':')) {
        fprintf(stderr, "Invalid MAC '%s' in MMC\n", buf);
        goto out_closemacfile;
    }

    strncpy(mac, buf, 17);
    mac[17] = 0;
    ret = 0;
out_closemacfile:
    fclose(macfile);
out_unmount:
    umount(mountpoint);
out_rmmountpoint:
    rmdir(mountpoint);
out:
    return ret;
}

int get_mac_from_fuse(char *mac)
{
    int ret;
    FILE *file;
    char buf[64+1], *macbuf;

    file = fopen(VMISC_PATH "/ventana_fuse_reservedodm", "r");
    if (!file) {
        fprintf(stderr, "Failed to open ventana_fuse_reservedodm\n");
        return -1;
    }

    ret = fscanf(file, "%64s", buf);
    fclose(file);
    if (ret != 1) {
        fprintf(stderr, "Failed to read fuse\n");
        return -1;
    }

    /* the last 24 characters */
    macbuf = &buf[strlen(buf) - 24];

    if (!strncmp(macbuf, "000000000000", 12)) {
        fprintf(stderr, "Fuse contains no MAC info\n");
        return -1;
    }

    snprintf(mac, 18, "%c%c:%c%c:%c%c:%c%c:%c%c:%c%c",
             macbuf[0], macbuf[1], macbuf[2], macbuf[3],
             macbuf[4], macbuf[5], macbuf[6], macbuf[7],
             macbuf[8], macbuf[9], macbuf[10], macbuf[11]);
    return 0;
}

int main(int argc, char *argv[])
{
    int vendor, ret;
    char *nvram_filename, *src;
    char mac[18];

    vendor = get_wifi_vendor();
    if (vendor == WIFI_VENDOR_MURATA) {
        nvram_filename = "/system/etc/wifi/nvram.txt";
    } else if (vendor == WIFI_VENDOR_AZW) {
        char model[50];
        property_get("ro.product.model", model, NULL);
        if (!strcmp(model, "Slider SL101"))
            nvram_filename = "/system/etc/wifi/nvram_a_sl101.txt";
        else
            nvram_filename = "/system/etc/wifi/nvram_a.txt";
    } else {
        fprintf(stderr, "Unknown WiFi vendor %d\n", vendor);
        return EXIT_FAILURE;
    }
    printf("Using NVRAM base %s\n", nvram_filename);

    src = "MMC";
    ret = get_mac_from_mmc(mac);
    if (ret) {
        src = "fuse";
        ret = get_mac_from_fuse(mac);
    }
    if (ret) {
        fprintf(stderr, "Failed to get MAC\n");
        return EXIT_FAILURE;
    }
    printf("MAC %s read from %s\n", mac, src);

    ret = copy_nvram(nvram_filename, mac);
    if (ret) {
        fprintf(stderr, "Failed to copy %s\n", nvram_filename);
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
