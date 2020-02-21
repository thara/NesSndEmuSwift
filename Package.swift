// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NesSndEmuSwift",
    products: [
        .library(
            name: "NesSndEmuSwift",
            targets: ["NesSndEmuSwift"])
    ],
    targets: [
        .target(name: "NesSndEmuCpp"),
        .target(name: "NesSndEmuCppWrapper", dependencies: ["NesSndEmuCpp"]),
        .target(name: "NesSndEmuSwift", dependencies: ["NesSndEmuCppWrapper"]),
        .target(name: "NesSndEmuSwiftDemo", dependencies: ["NesSndEmuSwift"])
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx98
)
