import NesSndEmuSwift

func nopDmcReader(addr: UInt32) -> Int32 {
    return 0x55
}

class SimpleApu {

    let apu = NesApu()
    let buf = BlipBuffer()
    var time: Int = 0
    var frameLength: Int = 29780

    init() {
        apu.dmcReader(nopDmcReader)
    }

    func clock() -> Int {
        time += 4
        return time
    }

    func dmcReader(_ callback: @escaping NesApu.DMCCallback) {
        apu.dmcReader(callback)
    }

    func sampleRate(_ rate: Int) {
        apu.output(buffer: buf)
        buf.clockRate = 1789773
        buf.formSampleRate(perSeconds: rate)
    }

    func writeRegister(addr: UInt32, data: Int32) {
        apu.writeRegister(cpuTime: clock(), cpuAddress: addr, data: data)
    }

    func readStatus() -> Int32 {
        return apu.readStatus(cpuTime: clock())
    }

    func endFrame() {
        time = 0
        frameLength ^= 1
        apu.endFrame(cpuTime: frameLength)
        buf.endFrame(frameLength)
    }

    var availableSamples: Int {
        buf.availableSamples
    }

    func readSamples(into dest: inout [Int16], until maxSamples: Int) -> Int {
        return buf.readSamples(into: &dest, until: maxSamples)
    }
}
