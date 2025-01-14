#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include <stddef.h>

// Structs for WILC configurations
struct wilc_cfg_string_vals {
    char firmware_version[128];
    char mac_address[128];
    char assoc_rsp[128];
};

struct wilc_cfg_s {
    int id;
    char *str;
};

struct wilc_cfg {
    void *b;                          // Byte config
    void *hw;                         // Half-word config
    void *w;                          // Word config
    struct wilc_cfg_s *s;             // String config
    struct wilc_cfg_string_vals *str_vals;
};

struct wilc {
    struct wilc_cfg cfg;
};

// Define IDs (replace with actual values as needed)
#define WID_FIRMWARE_VERSION 1
#define WID_MAC_ADDR 2
#define WID_ASSOC_RES_INFO 3
#define WID_NIL 4

// Define configuration arrays
unsigned char g_cfg_byte[] = {0x01, 0x02, 0x03};
unsigned short g_cfg_hword[] = {0x1234, 0x5678};
unsigned int g_cfg_word[] = {0xDEADBEEF, 0xCAFEBABE};
struct wilc_cfg_s g_cfg_str[] = {{0, NULL}, {0, NULL}, {0, NULL}, {0, NULL}};

// The function being tested
int wilc_wlan_cfg_init(struct wilc *wl) {
    struct wilc_cfg_string_vals *str_vals;
    int i = 0;

    wl->cfg.b = malloc(sizeof(g_cfg_byte));
    if (!wl->cfg.b)
        return -1;

    memcpy(wl->cfg.b, g_cfg_byte, sizeof(g_cfg_byte));

    wl->cfg.hw = malloc(sizeof(g_cfg_hword));
    if (!wl->cfg.hw)
        goto out_b;

    memcpy(wl->cfg.hw, g_cfg_hword, sizeof(g_cfg_hword));

    wl->cfg.w = malloc(sizeof(g_cfg_word));
    if (!wl->cfg.w)
        goto out_hw;

    memcpy(wl->cfg.w, g_cfg_word, sizeof(g_cfg_word));

    wl->cfg.s = malloc(sizeof(g_cfg_str));
    if (!wl->cfg.s)
        goto out_w;

    memcpy(wl->cfg.s, g_cfg_str, sizeof(g_cfg_str));

    str_vals = malloc(sizeof(str_vals));
    if (!str_vals)
        goto out_s;

    wl->cfg.str_vals = str_vals;

    /* store the string cfg parameters */
    wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
    wl->cfg.s[i].str = str_vals->firmware_version;
	// printf("Firmware version: %p\n", (void *) &str_vals->firmware_version);
    i++;
    wl->cfg.s[i].id = WID_MAC_ADDR;
    wl->cfg.s[i].str = str_vals->mac_address;
    i++;
    wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
    wl->cfg.s[i].str = str_vals->assoc_rsp;
    i++;
    wl->cfg.s[i].id = WID_NIL;
    wl->cfg.s[i].str = NULL;

	printf("Before: %s\n", str_vals->firmware_version);
	strcpy(wl->cfg.s[0].str, "1.2.3");
	printf("After: %s\n", str_vals->firmware_version);

    return 0;

out_s:
    fprintf(1, "Cleaning s");
out_w:
    fprintf(1, "Cleaning w");
out_hw:
    fprintf(1, "Cleaning hw");
out_b:
    fprintf(1, "Cleaning b");
    return -1;
}

int main() {
    struct wilc wl;

    // Initialize and test the function
    if (wilc_wlan_cfg_init(&wl) != 0) {
        fprintf(1, "Failed to initialize WILC configuration.\n");
        exit(1);
    }

    fprintf(1, "WILC configuration initialized successfully.\n");
   
	exit(0);
}