import AppKit
import Foundation
import SiliconLibrary

/// Applications Manager is the responsible for loading all the information needed by the app
final class ApplicationsManager: ObservableObject {
  
  // MARK: - Private Properties
  
  private let silicon: Silicon
  
  // MARK: - Type Aliases
  
  typealias ApplicationsResult = Result<Applications, Error>
  typealias ViewState = ViewStateList<Applications>
  
  // MARK: - Properties
  
  @Published
  private(set) var filter: Filter = .none
  
  @Published
  private(set) var state: ViewState = .initial
  
  let buildConfiguration: BuildConfiguration
  
  // MARK: - Computed Properties
  
  var isFilterActive: Bool {
    filter != .none
  }
  
  var totalCount: Int {
    applications.count
  }
  
  var applications: Applications {
    guard case .list(let applications) = state else {
      return []
    }
    
    switch filter {
      case .silicon:
        return applications.filter(\.isAppleSiliconReady)
      case .electron:
        return applications.filter(\.isElectronApp)
      case .intel:
        return applications.filter { $0.isAppleSiliconReady == false }
      case .system:
        return applications.filter(\.isSystemApp)
      default:
        break
    }
    
    return applications
  }
  
  // MARK: - Lifecycle
  
  init() {
    let directories = NSSearchPathForDirectoriesInDomains(
      .applicationDirectory,
      .allDomainsMask,
      true
    )
    
    self.silicon = Silicon(
      directories: directories
    )
    
    // Check if the Hot Reloading was defined in the env var
    let path = ProcessInfo.processInfo
    let key = "SILICON_HOT_RELOADING"
    
    if path.environment[key] != nil {
      self.buildConfiguration = .hotReloading
    }
    else {
      #if DEBUG
      self.buildConfiguration = .debug
      #else
      self.buildConfiguration = .release
      #endif
    }
  }
}

// MARK: - Actions

extension ApplicationsManager {
  
  func filter(by filter: Filter) {
    self.filter = filter
  }
  
  func application(at index: Int) -> SiliconLibrary.Application {
    applications[index]
  }
  
  func scan() {
    state = .loading
    
    Task {
      let result = await loadApplications()
      
      state = switch result {
        case .success(let applications):
          .list(applications)
        case .failure:
          .error
      }
    }
  }
  
  private func loadApplications() async -> ApplicationsResult {
    await withCheckedContinuation { continuation in
      self.silicon.scan()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        continuation.resume(
          returning: .success(self.silicon.applications)
        )
      }
    }
  }
}
