#ifndef NES_APU_WRAPPER_H
#define NES_APU_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

const void* nes_apu_create();

void nes_apu_output(void* obj, void* buffer);
void nes_apu_dmc_reader(void* obj, int (*callback)(void* user_data, unsigned), void* user_data);
void nes_apu_write_register(void* obj, long cpu_time, unsigned cpu_addr, int data);
int nes_apu_read_status(void* obj, long cpu_time);
void nes_apu_end_frame(void* obj, long cpu_time);

#ifdef __cplusplus
}
#endif

#endif
