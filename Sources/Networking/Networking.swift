import Combine

public protocol Networking: Sendable {
  func run<T: Decodable>(_ route: Routing, completion: @escaping @Sendable (Result<T, Error>) -> Void)

  @available(iOS 13, *)
  @available(OSX 10.15, *)
  func run<T>(_ route: Routing) -> AnyPublisher<T, Error> where T : Decodable

  @available(iOS 13, *)
  @available(OSX 10.15, *)
  func run<T>(_ route: Routing) async throws -> T where T : Decodable
}
