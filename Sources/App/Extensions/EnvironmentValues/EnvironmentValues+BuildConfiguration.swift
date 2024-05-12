import protocol SwiftTUI.EnvironmentKey
import struct SwiftTUI.EnvironmentValues

// MARK: - BuildConfigurationEnvironmentKey

private struct BuildConfigurationEnvironmentKey: EnvironmentKey {
  static var defaultValue: BuildConfiguration { .debug }
}

extension EnvironmentValues {
  var buildConfiguration: BuildConfiguration {
    get { self[BuildConfigurationEnvironmentKey.self] }
    set { self[BuildConfigurationEnvironmentKey.self] = newValue }
  }
}
