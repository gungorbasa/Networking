import Combine

public protocol Networking {
  func run<T: Decodable>(_ route: Routing, completion: @escaping (Result<T, Error>) -> Void)

  @available(iOS 13, *)
  @available(OSX 10.15, *)
  func run<T>(_ route: Routing) -> AnyPublisher<T, Error> where T : Decodable
}
