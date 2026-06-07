/*
 * HyperBoost - GPU Governor Injector
 * Sets GPU governor to performance
 */
#include <stdio.h>
#include <stdlib.h>

#define GPU_GOV_PATH "/sys/class/kgsl/kgsl-3d0/devfreq/governor"

int main() {
    FILE *fp = fopen(GPU_GOV_PATH, "w");
    if (fp) {
        fprintf(fp, "performance");
        fclose(fp);
        printf("[✓] GPU governor set to performance\n");
    }
    return 0;
}