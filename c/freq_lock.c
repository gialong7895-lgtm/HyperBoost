/*
 * HyperBoost - CPU Frequency Locker
 * Locks CPU frequency to maximum
 */
#include <stdio.h>
#include <stdlib.h>

#define CPU_FREQ_PATH "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"

int main() {
    FILE *fp = fopen(CPU_FREQ_PATH, "w");
    if (fp) {
        fprintf(fp, "%d", 2803200);
        fclose(fp);
        printf("[✓] CPU frequency locked\n");
    } else {
        printf("[✗] Failed to lock CPU frequency\n");
    }
    return 0;
}