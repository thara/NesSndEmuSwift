import NesSndEmuCppWrapper

public class NesApu {
    var rawPointer: UnsafeMutableRawPointer

    init(rawPointer: UnsafeRawPointer) {
        self.rawPointer = UnsafeMutableRawPointer(mutating: rawPointer)
    }

    public init() {
        self.rawPointer = UnsafeMutableRawPointer(mutating: nes_apu_create())
    }

    deinit {
        rawPointer.deallocate()
    }

    public typealias DMCCallback = (UInt32) -> Int32

    class CallbackHolder {
        var dmcCallback: DMCCallback?
    }

    private var callbackHolder = CallbackHolder()
}

extension NesApu {

    public func output(buffer: BlipBuffer) {
        nes_apu_output(rawPointer, buffer.rawPointer)
    }

    public func dmcReader(_ callback: @escaping DMCCallback) {
        callbackHolder.dmcCallback = callback

        let userData = Unmanaged<CallbackHolder>.passRetained(self.callbackHolder).toOpaque()
        nes_apu_dmc_reader(
            rawPointer, { (userData: UnsafeMutableRawPointer?, address: UInt32) -> Int32 in
                guard let pointer = userData else { return Int32(address) }

                let holder = Unmanaged<CallbackHolder>.fromOpaque(pointer).takeUnretainedValue()
                return holder.dmcCallback!(address)
            }, userData)
    }

    public func writeRegister(cpuTime: Int, cpuAddress: UInt32, data: Int32) {
        nes_apu_write_register(rawPointer, cpuTime, cpuAddress, data)
    }

    public func readStatus(cpuTime: Int) -> Int32 {
        return nes_apu_read_status(rawPointer, cpuTime)
    }

    public func endFrame(cpuTime: Int) {
        nes_apu_end_frame(rawPointer, cpuTime)
    }
}
