#include "Blip_Buffer_Wrapper.h"

#include "Blip_Buffer.h"

template<typename T>
inline T* ptr(void* obj) {
    return reinterpret_cast<T*>(obj);
}

template<typename T>
inline const T* const_ptr(const void* obj) {
    return const_cast<T*>(reinterpret_cast<const T*>(obj));
}

const void* blip_buffer_init() {
    Blip_Buffer* obj = new Blip_Buffer();
    return (void *)obj;
}

const char* blip_buffer_set_sample_rate(void* obj, long samples_per_sec, int msec_length) {
    return ptr<Blip_Buffer>(obj)->sample_rate(samples_per_sec, msec_length);
}

long blip_buffer_get_length(const void* obj) {
    return const_ptr<Blip_Buffer>(obj)->length();
}

long blip_buffer_get_sample_rate(const void* obj) {
    return const_ptr<Blip_Buffer>(obj)->sample_rate();
}

void blip_buffer_set_clock_rate(void* obj, long cps) {
    ptr<Blip_Buffer>(obj)->clock_rate(cps);
}

long blip_buffer_get_clock_rate(const void* obj) {
    return const_ptr<Blip_Buffer>(obj)->clock_rate();
}

void blip_buffer_bass_freq(void* obj, int frequency) {
    ptr<Blip_Buffer>(obj)->bass_freq(frequency);
}

void blip_buffer_clear(void* obj, int entire_buffer) {
    return ptr<Blip_Buffer>(obj)->clear(entire_buffer);
}

void blip_buffer_end_frame(void* obj, long time) {
    ptr<Blip_Buffer>(obj)->end_frame(time);
}

long blip_buffer_samples_avail(const void* obj) {
    return const_ptr<Blip_Buffer>(obj)->samples_avail();
}

long blip_buffer_read_samples(void* obj, short* dest, long max_samples, int stereo) {
    return ptr<Blip_Buffer>(obj)->read_samples(dest, max_samples, stereo);
}

void blip_buffer_remove_samples(void* obj, long count) {
    ptr<Blip_Buffer>(obj)->remove_samples(count);
}

int blip_buffer_output_latency(const void* obj) {
    return const_ptr<Blip_Buffer>(obj)->output_latency();
}
