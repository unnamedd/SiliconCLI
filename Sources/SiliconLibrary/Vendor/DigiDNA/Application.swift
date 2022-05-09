/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2020 DigiDNA - www.imazing.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/**
 * Original Project: https://github.com/DigiDNA/Silicon
 * Created by DigiDNA SARL
 * GitHub: https://github.com/DigiDNA
 *
 * Modified by Thiago Holanda
 * GitHub: https://github.com/unnamedd
 */

import Foundation

public typealias Applications = [Application]

// MARK: - Application

public struct Application {
  // MARK: - Lifecycle

  public init?(path: String) {
    var isDir = ObjCBool(booleanLiteral: false)

    if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) == false || isDir.boolValue == false {
      return nil
    }

    let plist = "\(path)/Contents/Info.plist"

    if FileManager.default.fileExists(atPath: plist) == false {
      return nil
    }

    guard
      let data = FileManager.default.contents(atPath: plist),
      let info = try? PropertyListSerialization.propertyList(
        from: data,
        options: [],
        format: nil
      ) as? [String: Any]
    else {
      return nil
    }

    guard let executable: String = {
      if
        let bundle = info["CFBundleExecutable"] as? String,
        bundle != "WRAPPEDPRODUCTNAME"
      {
        return bundle
      }

      return ((path as NSString).lastPathComponent as NSString).deletingPathExtension
    }()
    else {
      return nil
    }

    let binary = "\(path)/Contents/MacOS/\(executable)"

    if FileManager.default.fileExists(atPath: binary) == false {
      return nil
    }

    guard let macho = MachOFile(path: binary) else {
      return nil
    }

    var version: String?
    if let bundleVersion = info["CFBundleShortVersionString"] as? String {
      version = bundleVersion
    }

    var isElectron = false
    ["Electron.framework", "Electron Framework.framework"].forEach {
      let frameworkPath = "\(path)/Contents/Frameworks/\($0)"
      
      if FileManager.default.fileExists(atPath: frameworkPath) {
        isElectron = true
      }
    }

    architectures = macho.architectures
    bundleID = info["CFBundleIdentifier"] as? String
    isElectronApp = isElectron
    isSystemApp = path.hasPrefix("/System")
    name = FileManager.default.displayName(atPath: path)
    self.path = path
    self.version = version

    if macho.architectures.count == 1 {
      if macho.architectures.contains("arm64") {
        isAppleSiliconReady = true
        architecture = "Apple"
      }
      else if macho.architectures.contains("x86_64") {
        isAppleSiliconReady = false
        architecture = "Intel 64"
      }
      else if macho.architectures.contains("i386") {
        isAppleSiliconReady = false
        architecture = "Intel 32"
      }
      else if macho.architectures.contains("ppc") {
        isAppleSiliconReady = false
        architecture = "PowerPC"
      }
      else {
        isAppleSiliconReady = false
        architecture = "Unknown"
      }
    }
    else {
      if macho.architectures.contains("arm64") {
        isAppleSiliconReady = true
        architecture = "Universal"
      }
      else if macho.architectures.contains("ppc"), macho.architectures.contains("i386"), macho.architectures.contains("x86_64") {
        isAppleSiliconReady = false
        architecture = "PowerPC/Intel 32/64"
      }
      else if macho.architectures.contains("ppc"), macho.architectures.contains("x86_64") {
        isAppleSiliconReady = false
        architecture = "PowerPC/Intel 64"
      }
      else if macho.architectures.contains("ppc"), macho.architectures.contains("i386") {
        isAppleSiliconReady = false
        architecture = "PowerPC/Intel 32"
      }
      else if macho.architectures.contains("i386"), macho.architectures.contains("x86_64") {
        isAppleSiliconReady = false
        architecture = "Intel 32/64"
      }
      else {
        isAppleSiliconReady = false
        architecture = "Unknown"
      }
    }
  }

  // MARK: - Public

  public private(set) var architecture: String
  public private(set) var architectures: [String]
  public private(set) var bundleID: String?
  public private(set) var isAppleSiliconReady: Bool
  public private(set) var isElectronApp: Bool
  public private(set) var isSystemApp: Bool
  public private(set) var name: String
  public private(set) var path: String
  public private(set) var version: String?
}
