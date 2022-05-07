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

public class BinaryStream {

  // MARK: - Lifecycle

  public convenience init(path: String) throws {
    do {
      try self.init(url: URL(fileURLWithPath: path))
    }
    catch {
      throw error
    }
  }

  public init(url: URL) throws {
    var dir: ObjCBool = false

    if FileManager.default.fileExists(atPath: url.path, isDirectory: &dir) == false {
      throw Error.fileDoesNotExist(url.path)
    }

    if dir.boolValue {
      throw Error.fileIsADirectory(url.path)
    }

    guard let stream = InputStream(url: url) else {
      throw Error.fileIsNotReadable(url.path)
    }

    self.url = url
    self.stream = stream

    stream.open()
  }

  deinit {
    stream.close()
  }

  // MARK: - Public

  public enum Error: Swift.Error {
    case fileDoesNotExist(String)
    case fileIsADirectory(String)
    case fileIsNotReadable(String)
    case readError(String)
    case invalidFixedFloatingPointFormat(String)
  }

  public func readUnsignedChar() throws -> UInt8 {
    do {
      let buffer = try read(size: 1)

      return buffer[0]
    }
    catch {
      throw error
    }
  }

  public func readSignedChar() throws -> Int8 {
    do {
      let buffer = try read(size: 1)

      return Int8(buffer[0])
    }
    catch {
      throw error
    }
  }

  public func readBigEndianUnsignedShort() throws -> UInt16 {
    do {
      let buffer = try read(size: 2)
      let n1 = UInt16(buffer[0])
      let n2 = UInt16(buffer[1])

      return (n1 << 8) | n2
    }
    catch {
      throw error
    }
  }

  public func readLittleEndianUnsignedShort() throws -> UInt16 {
    do {
      let buffer = try read(size: 2)
      let n1 = UInt16(buffer[1])
      let n2 = UInt16(buffer[0])

      return (n1 << 8) | n2
    }
    catch {
      throw error
    }
  }

  public func readBigEndianUnsignedInteger() throws -> UInt32 {
    do {
      let buffer = try read(size: 4)
      let n1 = UInt32(buffer[0])
      let n2 = UInt32(buffer[1])
      let n3 = UInt32(buffer[2])
      let n4 = UInt32(buffer[3])

      return (n1 << 24) | (n2 << 16) | (n3 << 8) | n4
    }
    catch {
      throw error
    }
  }

  public func readLittleEndianUnsignedInteger() throws -> UInt32 {
    do {
      let buffer = try read(size: 4)
      let n1 = UInt32(buffer[3])
      let n2 = UInt32(buffer[2])
      let n3 = UInt32(buffer[1])
      let n4 = UInt32(buffer[0])

      return (n1 << 24) | (n2 << 16) | (n3 << 8) | n4
    }
    catch {
      throw error
    }
  }

  public func readBigEndianUnsignedLong() throws -> UInt64 {
    do {
      let buffer = try read(size: 8)
      let n1 = UInt64(buffer[0])
      let n2 = UInt64(buffer[1])
      let n3 = UInt64(buffer[2])
      let n4 = UInt64(buffer[3])
      let n5 = UInt64(buffer[4])
      let n6 = UInt64(buffer[5])
      let n7 = UInt64(buffer[6])
      let n8 = UInt64(buffer[7])

      var res = (n1 << 56)
      res |= (n2 << 48)
      res |= (n3 << 40)
      res |= (n4 << 32)
      res |= (n5 << 24)
      res |= (n6 << 16)
      res |= (n7 << 8)
      res |= n8

      return res
    }
    catch {
      throw error
    }
  }

  public func readLittleEndianUnsignedLong() throws -> UInt64 {
    do {
      let buffer = try read(size: 8)
      let n1 = UInt64(buffer[7])
      let n2 = UInt64(buffer[6])
      let n3 = UInt64(buffer[5])
      let n4 = UInt64(buffer[4])
      let n5 = UInt64(buffer[3])
      let n6 = UInt64(buffer[2])
      let n7 = UInt64(buffer[1])
      let n8 = UInt64(buffer[0])

      var result = (n1 << 56)
      result |= (n2 << 48)
      result |= (n3 << 40)
      result |= (n4 << 32)
      result |= (n5 << 24)
      result |= (n6 << 16)
      result |= (n7 << 8)
      result |= n8

      return result
    }
    catch {
      throw error
    }
  }

  public func readNULLTerminatedString() throws -> String {
    var value = String()

    while true {
      do {
        let character = try read(size: 1)[0]

        if character == 0 {
          break
        }

        value.append(Character(UnicodeScalar(character)))
      }
      catch {
        throw error
      }
    }

    return value
  }

  public func read(size: UInt) throws -> [UInt8] {
    if size == 0 {
      return []
    }

    let buffer = UnsafeMutablePointer<UInt8>.allocate(
      capacity: Int(size)
    )

    defer {
      buffer.deallocate()
    }

    if stream.read(buffer, maxLength: Int(size)) != Int(size) {
      throw Error.readError(url.path)
    }

    var array = [UInt8]()

    for index in 0 ..< size {
      array.append(buffer[Int(index)])
    }

    return array
  }

  // MARK: - Private

  private var stream: InputStream
  private var url: URL

}
