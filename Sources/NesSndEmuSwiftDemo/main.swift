let apu = SimpleApu()

let sampleRate = 44100

apu.sampleRate(sampleRate)

func readDMC(addr: UInt32) -> Int32 {
    return 0
}

var volume: Int = 0

func rand() -> Int32 {
    var g = SystemRandomNumberGenerator()
    return .random(in: 0..<Int32.max, using: &g)
}

func emulateFrame() {
    apu.writeRegister(addr: 0x4000, data: Int32(0xb0 | volume))
    volume -= 1
    if volume < 0 {
        volume = 15
        apu.writeRegister(addr: 0x4015, data: 0x01)
        apu.writeRegister(addr: 0x4002, data: rand() & 0xff)
        apu.writeRegister(addr: 0x4003, data: (rand() & 3) | 0x11)
    }
    apu.endFrame()
}

let wave = try WaveWriter(rate: sampleRate, path: "out.wav")

func playSamples(_ samples: inout [Int16], _ count: Int) {
    var p = UnsafeMutablePointer<Int16>.allocate(capacity: samples.count * MemoryLayout<Int16>.size)
    p.initialize(from: &samples, count: samples.count)
    wave.write(from: &p, remain: count)
}

apu.dmcReader(readDMC)

for _ in stride(from: 60 * 4, to: 0, by: -1) {
    emulateFrame()

    let bufferSize = 2048
    var buf = [Int16](repeating: 0, count: bufferSize)

    let count = apu.readSamples(into: &buf, until: bufferSize)
    playSamples(&buf, count)
}

wave.generate()
