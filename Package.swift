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
      name: "SiliconLibrary",
      targets: [
        "SiliconLibrary",
      ]
    ),
  ],
  targets: [
    .target(
      name: "SiliconLibrary"
    ),
    .executableTarget(
      name: "Silicon",
      dependencies: [
        "SiliconLibrary",
      ]
    ),
  ]
)
