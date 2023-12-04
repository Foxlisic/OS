#include <stdio.h>
#include <stdlib.h>

// Чтение сектора и запись в образ диска
int main(int argc, char** argv) {

    unsigned char boot[512];

    for (int i = 0; i < 512; i++) boot[i] = 0;

    FILE* a = fopen("boot.bin", "rb");
    FILE* b = fopen("../c.img", "rb+");

    // Записать 1 байт
    fseek(b, 32*1024*1024-1, SEEK_SET);
    fwrite(boot, 1, 1, b);
    fseek(b, 0, SEEK_SET);

    // Boot BIOS Signature
    boot[510] = 0x55;
    boot[511] = 0xAA;

    fread(boot, 1, 512, a);
    fwrite(boot, 1, 512, b);

    fclose(a);
    fclose(b);

    return 0;
}
