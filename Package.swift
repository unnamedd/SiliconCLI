// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "Silicon",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .executable(
      name: "silicon",
      targets: [
        "App",
      ]
    ),
    .executable(
      name: "silicon-cli",
      targets: [
        "CLI",
      ]
    ),
    .library(
      name: "SiliconLibrary",
      targets: [
        "SiliconLibrary",
      ]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/rensbreur/SwiftTUI",
      branch: "main"
    )
  ],
  targets: [
    .target(
      name: "SiliconLibrary"
    ),
    .executableTarget(
      name: "App",
      dependencies: [
        "SiliconLibrary",
        .product(
          name: "SwiftTUI",
          package: "SwiftTUI"
        ),
      ]
    ),
    .executableTarget(
      name: "CLI",
      dependencies: [
        "SiliconLibrary",
      ]
    ),
  ]
)
