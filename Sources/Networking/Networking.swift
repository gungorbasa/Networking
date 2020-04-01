import Combine

public protocol Networking {
  func run<T: Decodable>(_ route: Routing, completion: @escaping (Result<T, Error>) -> Void)

  @available(iOS 13, *)
  @available(OSX 10.15, *)
  func run<T>(_ route: Routing) -> AnyPublisher<T, Error> where T : Decodable
}

public struct Network: Networking {
  private let network = NativeNetwork()

  public init() {}

  public func run<T>(_ route: Routing, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
    network.run(route, completion: completion)
  }

  @available(iOS 13, *)
  @available(OSX 10.15, *)
  public func run<T>(_ route: Routing) -> AnyPublisher<T, Error> where T : Decodable {
    return network.run(route)
  }
}
