
// MARK: ApplicationsManager.Filter

extension ApplicationsManager {
  enum Filter: CaseIterable, CustomStringConvertible {
    case none
    case silicon
    case electron
    case intel
    case system

    // MARK: - Internal

    var description: String {
      switch self {
      case .silicon:
        "Silicon"
      case .electron:
        "Electron-based"
      case .intel:
        "Intel (x86-64)"
      case .system:
        "System"
      default:
        ""
      }
    }
  }
}
