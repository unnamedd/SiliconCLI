// MARK: - ViewStateProtocol

private protocol ViewStateProtocol {
  static var initial: Self { get }
  static var error: Self { get }
  static var loading: Self { get }
}

// MARK: - ViewStateProtocol Extension

private extension ViewStateProtocol {
  var errorDescription: String {
    "Something went wrong"
  }

  var loadingDescription: String {
    "Loading..."
  }

  var noneDescription: String {
    ""
  }
}

// MARK: - ViewStateObjectProtocol

private protocol ViewStateObjectProtocol: ViewStateProtocol {
  associatedtype T
  static func object(_ value: T) -> Self
}

// MARK: - ViewStateContentProtocol

private protocol ViewStateContentProtocol: ViewStateProtocol {
  static var content: Self { get }
}

// MARK: - ViewStateListProtocol

private protocol ViewStateListProtocol: ViewStateProtocol {
  associatedtype T
  static func list(_ value: T) -> Self
}

// MARK: - ViewStateObject

@frozen
public enum ViewStateObject<T> {
  case initial
  case error
  case loading
  case object(T)
}

// MARK: ViewStateObjectProtocol

extension ViewStateObject: ViewStateObjectProtocol {}

// MARK: CustomStringConvertible

extension ViewStateObject: CustomStringConvertible {
  public var description: String {
    switch self {
    case .error: errorDescription
    case .loading: loadingDescription
    default: noneDescription
    }
  }
}

// MARK: Equatable

extension ViewStateObject: Equatable {
  public static func == (lhs: ViewStateObject<T>, rhs: ViewStateObject<T>) -> Bool {
    switch (lhs, rhs) {
    case (.initial, .initial): true
    case (.error, .error): true
    case (.loading, .loading): true
    case (.object, .object): true
    default: false
    }
  }
}


// MARK: - ViewStateContent

@frozen
public enum ViewStateContent: ViewStateContentProtocol {
  case initial
  case error
  case loading
  case content
}

// MARK: CustomStringConvertible

// extension ViewStateContent: ViewStateContentProtocol {}

extension ViewStateContent: CustomStringConvertible {
  public var description: String {
    switch self {
    case .error: errorDescription
    case .loading: loadingDescription
    default: noneDescription
    }
  }
}

// MARK: Equatable

extension ViewStateContent: Equatable {
  public static func == (lhs: ViewStateContent, rhs: ViewStateContent) -> Bool {
    switch (lhs, rhs) {
    case (.initial, .initial): true
    case (.error, .error): true
    case (.loading, .loading): true
    case (.content, .content): true
    default: false
    }
  }
}

// MARK: - ViewStateList

@frozen
public enum ViewStateList<T> {
  case initial
  case error
  case loading
  case list(T)
}

// MARK: ViewStateListProtocol

extension ViewStateList: ViewStateListProtocol {}

// MARK: CustomStringConvertible

extension ViewStateList: CustomStringConvertible {
  public var description: String {
    switch self {
    case .error: errorDescription
    case .loading: loadingDescription
    default: noneDescription
    }
  }
}

// MARK: Equatable

extension ViewStateList: Equatable {
  public static func == (lhs: ViewStateList<T>, rhs: ViewStateList<T>) -> Bool {
    switch (lhs, rhs) {
    case (.initial, .initial): true
    case (.error, .error): true
    case (.loading, .loading): true
    case (.list, .list): true
    default: false
    }
  }
}

