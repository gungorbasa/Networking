//
//  NativeNetwork.swift
//  
//
//  Created by Gungor Basa on 4/1/20.
//

import Foundation
import Combine

final class NativeNetwork {
  private let session: URLSession = .shared
}


extension NativeNetwork: Networking {
  @available(iOS 13, *)
  @available(OSX 10.15, *)
  func run<T: Decodable>(_ route: Routing) -> AnyPublisher<T, Error> {
    let request = URLRequest(route)!
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }

  func run<T: Decodable>(_ route: Routing, completion: @escaping (Result<T, Error>) -> Void) {
    guard let request = URLRequest(route) else {
      completion(.failure(HTTPResponseError.badURL))
      return
    }
    let dataTask = session.dataTask(with: request) { result in
      switch result {
      case .success((_, let data)):
        do {
          let object  = try JSONDecoder().decode(T.self, from: data)
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

