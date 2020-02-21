#ifndef BLIP_BUFFER_WRAPPER_H
#define BLIP_BUFFER_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

const void* blip_buffer_init();

const char* blip_buffer_set_sample_rate(void* obj, long samples_per_sec, int msec_length);
long blip_buffer_get_length(const void* obj);
long blip_buffer_get_sample_rate(const void* obj);
void blip_buffer_set_clock_rate(void* obj, long cps);
long blip_buffer_get_clock_rate(const void* obj);
void blip_buffer_bass_freq(void* obj, int frequency);
void blip_buffer_clear(void* obj, int entire_buffer);
void blip_buffer_end_frame(void* obj, long time);
long blip_buffer_samples_avail(const void* obj);
long blip_buffer_read_samples(void* obj, short* dest, long max_samples, int stereo);
void blip_buffer_remove_samples(void* obj, long count);
int blip_buffer_output_latency(const void* obj);

#ifdef __cplusplus
}
#endif

#endif
