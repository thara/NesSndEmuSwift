import Foundation

let bufferSize = 32768 * 2
let headerSize = 0x2C

class WaveWriter {

    let file: FileHandle
    let rate: Int
    var sampleCount: Int = 0
    var bufferPointer: UnsafeMutablePointer<UInt8>
    var buffer = [UInt8](repeating: 0, count: bufferSize)
    var bufferPostion: Int = headerSize
    var channelCount: Int = 0

    var stereo: Bool {
        get { channelCount == 2 }
        set { channelCount = newValue ? 2 : 1 }
    }

    public init(rate: Int, path: String) throws {
        self.rate = rate
        FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        let url = URL(fileURLWithPath: path)
        self.file = try FileHandle(forWritingTo: url)

        self.bufferPointer = UnsafeMutablePointer.allocate(capacity: bufferSize * MemoryLayout<UInt8>.size)
        self.bufferPointer.initialize(from: &buffer, count: bufferSize)

        self.stereo = false
    }
}

extension WaveWriter {

    public func write(from samples: inout UnsafeMutablePointer<Int16>, remain: Int, skip: Int = 1) {
        sampleCount &+= remain

        var remain = remain
        while 0 < remain {
            if bufferSize <= bufferPostion {
                flush()
            }

            var n = UInt((bufferSize - bufferPostion) / MemoryLayout<Int16>.size)
            if remain < n {
                n = UInt(remain)
            }
            remain &-= Int(n)

            // to little endian
            var p = bufferPointer + bufferPostion
            for _ in stride(from: n, to: 0, by: -1) {
                let s = samples.pointee
                samples += skip
                p.pointee = UInt8(truncatingIfNeeded: s)
                p += 1
                p.pointee = UInt8(truncatingIfNeeded: s >> 8)
                p += 1
            }
            bufferPostion = p - bufferPointer
            assert(bufferPostion <= bufferSize)
        }
    }

    public func flush() {
        buffer = Array(UnsafeBufferPointer(start: bufferPointer, count: bufferPostion))

        if 0 < bufferPostion {
            file.write(Data(buffer[..<bufferPostion]))
        }
        bufferPostion = 0
    }

    public func generate() {
        flush()

        let dataSize = sampleCount * MemoryLayout<Int16>.size
        let restOfFile = headerSize - 8 + dataSize
        let frameSize = channelCount * MemoryLayout<Int16>.size
        let bps = rate * frameSize

        let header: [UInt8] = [
            UInt8(ascii: "R"), UInt8(ascii: "I"), UInt8(ascii: "F"), UInt8(ascii: "F"),
            u8(restOfFile), u8(restOfFile  >>  8),
            u8(restOfFile >> 16), u8(restOfFile >> 24),
            UInt8(ascii: "W"), UInt8(ascii: "A"), UInt8(ascii: "V"), UInt8(ascii: "E"),
            UInt8(ascii: "f"), UInt8(ascii: "m"), UInt8(ascii: "t"), UInt8(ascii: " "),
            0x10, 0, 0, 0,
            1, 0,
            u8(channelCount), 0,
            u8(rate), u8(rate  >>  8),
            u8(rate >> 16), u8(rate >> 24),
            u8(bps), u8(bps  >>  8),
            u8(bps >> 16), u8(bps >> 24),
            u8(frameSize), 0,
            16, 0,
            UInt8(ascii: "d"), UInt8(ascii: "a"), UInt8(ascii: "t"), UInt8(ascii: "a"),
            u8(dataSize), u8(dataSize  >>  8),
            u8(dataSize >> 16), u8(dataSize >> 24)
        ]

        file.seek(toFileOffset: 0)
        file.write(Data(header))
    }
}

func u8(_ value: Int) -> UInt8 {
    return UInt8(truncatingIfNeeded: value)
}
