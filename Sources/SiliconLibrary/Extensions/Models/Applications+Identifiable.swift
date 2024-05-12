import Foundation

extension Application: Identifiable {
  
  public var id: String {
    let value = "\(path)\(name)"
    
    guard let identifier = try? value.convertToMD5() else {
      return UUID.newIdentifier
    }
    
    return identifier
  }
}
