//  Copyright (c) 2022 Thiago Holanda
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import TSCBasic

public final class Silicon {
  private let directories: [AbsolutePath]
  private var applications: Applications

  public init(paths: [String]) {
    self.applications = []
    self.directories = paths.map { AbsolutePath($0) }
  }

  public convenience init(path: String) {
    self.init(paths: [path])
  }

  public func scan() {
    for directory in directories {
      do {
        let directoryContent = try localFileSystem.getDirectoryContents(directory)

        for content in directoryContent {
          guard content.hasSuffix(".app") else {
            continue
          }

          let path = directory.appending(component: content)
          guard let application = Application(path: path.pathString) else {
            continue
          }

          guard applications.firstIndex(where: { $0.bundleID == application.bundleID }) == nil else {
            continue
          }

          applications.append(application)
        }
      }
      catch {
        continue
      }
    }

    applications = applications.sorted()
  }

  public func generateOutput(format: OutputFormat) throws {
    switch format {
    case .json:
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted

      let object = Softwares(
        total: applications.count,
        applications: applications
      )
      
      let encodedValue = try encoder.encode(object)

      guard let formattedValue = String(data: encodedValue, encoding: .utf8) else {
        fatalError("Content couldn't be encoded to JSON")
      }

      print(formattedValue)

    case .text:
      applications.forEach { app in
        print(app)
      }
    }
  }
}

extension Silicon {
  public enum OutputFormat {
    case json
    case text
  }
}
