// swift-tools-version: 5.6
import PackageDescription

let package = Package(
  name: "Silicon",
  platforms: [
    .macOS(.v10_10),
  ],
  products: [
    .executable(
      name: "silicon",
      targets: [
        "Silicon",
      ]
    ),
    .library(
      name: "SiliconKit",
      targets: [
        "SiliconKit",
      ]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-tools-support-core.git",
      .upToNextMinor(from: "0.2.5")
    ),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      .upToNextMinor(from: "1.1.2")
    ),
  ],
  targets: [
    .target(
      name: "SiliconKit",
      dependencies: [
        .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
      ]
    ),
    .executableTarget(
      name: "Silicon",
      dependencies: [
        "SiliconKit",
        .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
  ]
)