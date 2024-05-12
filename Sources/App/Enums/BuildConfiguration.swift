import protocol SwiftTUI.EnvironmentKey
import struct SwiftTUI.EnvironmentValues

// MARK: - BuildConfiguration

enum BuildConfiguration: CustomStringConvertible {
  case debug
  case release
  case hotReloading

  // MARK: - Internal

  var description: String {
    switch self {
    case .debug: "Debug"
    case .release: "Release"
    case .hotReloading: "Hot Reloading"
    }
  }
}
