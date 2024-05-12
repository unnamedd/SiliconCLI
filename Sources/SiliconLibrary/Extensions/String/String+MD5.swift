import CryptoKit
import Foundation

// MARK: - StringError

enum StringError: Error {
  case convertStringToData
}

extension String {
  func convertToMD5() throws -> String {
    guard let data = data(using: .utf8) else {
      throw StringError.convertStringToData
    }

    let digest = Insecure.MD5.hash(data: data)

    let value = digest.map {
      String(format: "%02hhx", $0)
    }
    .joined()

    return value
  }
}
