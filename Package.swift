// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NesSndEmuSwift",
    products: [
        .library(
            name: "NesSndEmuSwift",
            targets: ["NesSndEmuSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "NesSndEmuCpp"),
        .target(name: "NesSndEmuSwift"),
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx98
)
