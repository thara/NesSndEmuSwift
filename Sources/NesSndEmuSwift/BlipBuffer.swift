import NesSndEmuCppWrapper

public class BlipBuffer {
    var rawPointer: UnsafeMutableRawPointer

    init(rawPointer: UnsafeRawPointer) {
        self.rawPointer = UnsafeMutableRawPointer(mutating: rawPointer)
    }

    public init() {
        self.rawPointer = UnsafeMutableRawPointer(mutating: blip_buffer_init())
    }

    deinit {
        rawPointer.deallocate()
    }
}

extension BlipBuffer {
    public func formSampleRate(perSeconds newRate: Int, millisecondsLength ms: Int32 = 1000 / 4) {
        blip_buffer_set_sample_rate(rawPointer, newRate, ms)
    }

    public var length: Int {
        return blip_buffer_get_length(rawPointer)
    }

    public var sampleRate: Int {
        return blip_buffer_get_sample_rate(rawPointer)
    }

    public var clockRate: Int {
        get { blip_buffer_get_clock_rate(rawPointer) }
        set { blip_buffer_set_clock_rate(rawPointer, newValue) }
    }

    public func formBassFrequency(by value: Int32) {
        blip_buffer_bass_freq(rawPointer, value)
    }

    public func clear(entireBuffer: Bool = true) {
        blip_buffer_clear(rawPointer, entireBuffer ? 1 : 0)
    }

    public func endFrame(_ time: Int) {
        blip_buffer_end_frame(rawPointer, time)
    }

    public var availableSamples: Int {
        return blip_buffer_samples_avail(rawPointer)
    }

    @discardableResult
    public func readSamples(into dest: inout [Int16], until maxSamples: Int, stereo: Bool = false) -> Int {
        let destPointer = UnsafeMutablePointer<Int16>.allocate(capacity: dest.count * MemoryLayout<Int16>.size)
        destPointer.initialize(from: &dest, count: dest.count)
        let result = blip_buffer_read_samples(rawPointer, destPointer, maxSamples, stereo ? 1 : 0)
        dest = Array(UnsafeBufferPointer(start: destPointer, count: dest.count))
        return result
    }

    public func removeSamples(count: Int) {
        blip_buffer_remove_samples(rawPointer, count)
    }

    public var outputLatency: Int32 {
        return blip_buffer_output_latency(rawPointer)
    }
}
