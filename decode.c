#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

const char *EIGHT_BIT_REGISTERS[8] = {"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"};
const char *SIXTEEN_BIT_REGISTERS[8] = {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"};

const char *EFFECTIVE_ADDRESS_MODE_00[8] = {
    "bx+si", "bx+di", "bp+si", "bp+di", "si", "di", "Direct address", "bx"
};
const char *EFFECTIVE_ADDRESS_MODE_01[8] = {
    "bx+si", "bx+di", "bp+si", "bp+di", "si", "di", "bp", "bx"
};
const char *EFFECTIVE_ADDRESS_MODE_10[8] = {
    "bx+si", "bx+di", "bp+si", "bp+di", "si", "di", "bp", "bx"
};

void print_mov_reg_mem(uint8_t *bytes, int *index, int len) {
    int d = (bytes[*index] & 0x2) >> 1;
    int w = (bytes[*index] & 0x1);
    if (*index + 1 >= len) return;

    int mod_field = (bytes[*index + 1] & 0xC0) >> 6;
    int r_m_field = bytes[*index + 1] & 0x07;
    int reg_field = (bytes[*index + 1] & 0x38) >> 3;
    const char **register_type = w ? SIXTEEN_BIT_REGISTERS : EIGHT_BIT_REGISTERS;
    const char **effective_address = NULL;

    switch (mod_field) {
        case 0: effective_address = EFFECTIVE_ADDRESS_MODE_00; break;
        case 1: effective_address = EFFECTIVE_ADDRESS_MODE_01; break;
        case 2: effective_address = EFFECTIVE_ADDRESS_MODE_10; break;
        case 3: effective_address = register_type; break;
    }

    char source[64] = {0}, destination[64] = {0};
    if (d == 0) {
        snprintf(source, sizeof(source), "%s", register_type[reg_field]);
        snprintf(destination, sizeof(destination), "%s", effective_address[r_m_field]);
    } else {
        snprintf(source, sizeof(source), "%s", effective_address[r_m_field]);
        snprintf(destination, sizeof(destination), "%s", register_type[reg_field]);
    }

    if (mod_field == 0 && r_m_field == 6) {
        // Direct address, 16-bit displacement
        if (*index + 3 < len) {
            int addr = bytes[*index + 2] | (bytes[*index + 3] << 8);
            snprintf(d == 0 ? destination : source, 64, "+0x%x", addr);
            (*index) += 2;
        }
    } else if (mod_field == 1) {
        // 8-bit displacement
        if (*index + 2 < len) {
            int disp = (int8_t)bytes[*index + 2];
            char disp_str[16];
            snprintf(disp_str, sizeof(disp_str), "%+d", disp);
            strncat(d == 0 ? destination : source, disp_str, 64 - strlen(d == 0 ? destination : source) - 1);
            (*index) += 1;
        }
    } else if (mod_field == 2) {
        // 16-bit displacement
        if (*index + 3 < len) {
            int disp = bytes[*index + 2] | (bytes[*index + 3] << 8);
            char disp_str[16];
            snprintf(disp_str, sizeof(disp_str), "+0x%x", disp);
            strncat(d == 0 ? destination : source, disp_str, 64 - strlen(d == 0 ? destination : source) - 1);
            (*index) += 2;
        }
    }

    if (mod_field != 3) {
        char buf[64];
        snprintf(buf, sizeof(buf), "[%s]", d == 0 ? destination : source);
        if (d == 0)
            snprintf(destination, sizeof(destination), "%s", buf);
        else
            snprintf(source, sizeof(source), "%s", buf);
    }

    printf("mov %s,%s\n", destination, source);
    (*index) += 1;
}

void print_mov_imm_to_reg(uint8_t *bytes, int *index, int len) {
    int w = (bytes[*index] & 0x08) >> 3;
    int reg_code = bytes[*index] & 0x07;
    const char **register_type = w ? SIXTEEN_BIT_REGISTERS : EIGHT_BIT_REGISTERS;
    char imm[16];
    if (w == 0) {
        if (*index + 1 < len)
            snprintf(imm, sizeof(imm), "0x%x", bytes[*index + 1]);
    } else {
        if (*index + 2 < len) {
            int val = bytes[*index + 1] | (bytes[*index + 2] << 8);
            snprintf(imm, sizeof(imm), "0x%x", val);
        }
    }
    printf("mov %s,%s\n", register_type[reg_code], imm);
    (*index) += w ? 2 : 1;
}

void print_mov_mem_acc(uint8_t *bytes, int *index, int len, int to_acc) {
    int w = bytes[*index] & 0x01;
    char acc[3], addr[16];
    snprintf(acc, sizeof(acc), w ? "ax" : "al");
    if (w == 0) {
        if (*index + 1 < len)
            snprintf(addr, sizeof(addr), "0x%x", bytes[*index + 1]);
    } else {
        if (*index + 2 < len) {
            int val = bytes[*index + 1] | (bytes[*index + 2] << 8);
            snprintf(addr, sizeof(addr), "0x%x", val);
        }
    }
    if (to_acc)
        printf("mov %s,[%s]\n", acc, addr);
    else
        printf("mov [%s],%s\n", addr, acc);
    (*index) += w ? 2 : 1;
}

int main(int argc, char *argv[]) {
    const char *filename = argc > 1 ? argv[1] : "./asm/single_register_mov";
    FILE *f = fopen(filename, "rb");
    if (!f) {
        perror("File open failed");
        return 1;
    }
    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);

    uint8_t *bytes = malloc(fsize);
    fread(bytes, 1, fsize, f);
    fclose(f);

    for (int i = 0; i < fsize; i++) {
        uint8_t b = bytes[i];
        if (b >= 0x88 && b <= 0x8B) {
            print_mov_reg_mem(bytes, &i, fsize);
        } else if (b >= 0xB0 && b <= 0xBF) {
            print_mov_imm_to_reg(bytes, &i, fsize);
        } else if (b == 0xA0 || b == 0xA1) {
            print_mov_mem_acc(bytes, &i, fsize, 1);
        } else if (b == 0xA2 || b == 0xA3) {
            print_mov_mem_acc(bytes, &i, fsize, 0);
        }
    }
    free(bytes);
    return 0;
}
