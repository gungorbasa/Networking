//
//  NativeNetwork.swift
//  
//
//  Created by Gungor Basa on 4/1/20.
//

import Foundation
import Combine

public final class NativeNetwork {
  private let session: URLSession = .shared
  private let jsonDecoder: JSONDecoder

  public init(decoder: JSONDecoder) {
    self.jsonDecoder = decoder
  }
}


extension NativeNetwork: Networking {
  @available(iOS 13, *)
  @available(OSX 10.15, *)
  public func run<T>(_ route: Routing) async throws -> T where T : Decodable {
    guard let request = URLRequest(route) else {
      throw HTTPResponseError.badURL
    }
    let (data, _) = try await URLSession.shared.data(for: request)
    return try jsonDecoder.decode(T.self, from: data)
  }

  @available(iOS 13, *)
  @available(OSX 10.15, *)
  public func run<T: Decodable>(_ route: Routing) -> AnyPublisher<T, Error> {
    let request = URLRequest(route)!
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: T.self, decoder: jsonDecoder)
      .eraseToAnyPublisher()
  }
  
  public func run<T: Decodable>(_ route: Routing, completion: @escaping @Sendable (Result<T, Error>) -> Void) {
    guard let request = URLRequest(route) else {
      completion(.failure(HTTPResponseError.badURL))
      return
    }
    let dataTask = session.dataTask(with: request) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success((_, let data)):
        do {
            let object  = try self.jsonDecoder.decode(T.self, from: data)
          completion(.success(object))
        } catch let error {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
    dataTask.resume()
  }
}
