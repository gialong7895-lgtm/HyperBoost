# HyperBoost C Source Makefile
CC = gcc
CFLAGS = -Wall -O2
TARGETS = freq_lock dirtypipe_exploit gpu_governor_injector fps_unlock_native memory_optimizer

all: $(TARGETS)

freq_lock: freq_lock.c
	$(CC) $(CFLAGS) -o freq_lock freq_lock.c

dirtypipe_exploit: dirtypipe_exploit.c
	$(CC) $(CFLAGS) -o dirtypipe_exploit dirtypipe_exploit.c

gpu_governor_injector: gpu_governor_injector.c
	$(CC) $(CFLAGS) -o gpu_governor_injector gpu_governor_injector.c

fps_unlock_native: fps_unlock_native.c
	$(CC) $(CFLAGS) -o fps_unlock_native fps_unlock_native.c

memory_optimizer: memory_optimizer.c
	$(CC) $(CFLAGS) -o memory_optimizer memory_optimizer.c

clean:
	rm -f $(TARGETS)