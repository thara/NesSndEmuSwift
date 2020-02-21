#include "Nes_Apu_Wrapper.h"

#include "Nes_Apu.h"

template<typename T>
inline T* ptr(void* obj) {
    return reinterpret_cast<T*>(obj);
}

const void* nes_apu_create() {
    Nes_Apu* obj = new Nes_Apu();
    return (void *)obj;
}

void nes_apu_output(void* obj, void* buffer) {
    Blip_Buffer* bf = static_cast<Blip_Buffer*>(buffer);
    ptr<Nes_Apu>(obj)->output(bf);
}

void nes_apu_dmc_reader(void* obj, int (*callback)(void* user_data, unsigned), void* user_data) {
    ptr<Nes_Apu>(obj)->dmc_reader(callback, user_data);
}

void nes_apu_write_register(void* obj, long cpu_time, unsigned cpu_addr, int data) {
    ptr<Nes_Apu>(obj)->write_register(cpu_time, cpu_addr, data);
}

int nes_apu_read_status(void* obj, long cpu_time) {
    return ptr<Nes_Apu>(obj)->read_status(cpu_time);
}

void nes_apu_end_frame(void* obj, long cpu_time) {
    ptr<Nes_Apu>(obj)->end_frame(cpu_time);
}

void nes_apu_reset(void* obj, int pal_timing, int initial_dmc_dac) {
    ptr<Nes_Apu>(obj)->reset(0 < pal_timing, initial_dmc_dac);
}
