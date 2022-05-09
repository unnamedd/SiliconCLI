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
import SiliconLibrary

@main
enum Tool {

  // MARK: - Internal

  static func main() throws {
    var options = CommandLine.arguments
    options.removeFirst()
    
    guard let option = options.first else {
      try run()
      return
    }
    
    switch option {
    case "-h", "--help":
      help()
    case "-j", "--json":
      try run(json: true)
    case "-v", "--version":
      version()
    default:
      try run()
    }
  }

  // MARK: - Private

  private static func run(json: Bool = false) throws {
    let directories = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .allDomainsMask, true)
    let silicon = Silicon(directories: directories)
    
    silicon.scan()
    
    try silicon.generateOutput(
      format: json ? .json : .text
    )
  }
  
  private static func help() {
    let output = """
     OVERVIEW: Generate a report for the list of apps in the computer and the architecture used
    
     USAGE: silicon [--json]
    
     OPTIONS:
       -j, --json       Print the information in the JSON format
       -h, --help       Show help information.
       -v, --version    Print current Silicon version
    """

    print(output)
  }
  
  private static func version() {
    let version = "0.1"
    
    let description = """
    silicon version: \(version)
    """
    
    print(description)
  }
}
