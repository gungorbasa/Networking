//
//  URLRequest.swift
//  
//
//  Created by Gungor Basa on 4/1/20.
//

import Foundation

extension URLRequest {
  init?(_ route: Routing) {
    guard let url = URLRequest.makeURLComponents(for: route)?.url else { return nil }
    self.init(url: url)
    self = requestHeaders(route.headers)
      .httpMethod(route.method)
      .requestHeaders(route.headers)
      .requestBody(route.body)
  }

  private func httpMethod(_ method: HTTPMethod) -> URLRequest {
    var mutableRequest = self
    mutableRequest.httpMethod = method.rawValue
    return mutableRequest
  }

  private func requestHeaders(_ headers: [String: String]) -> URLRequest {
    var mutableRequest = self
    headers.forEach { (key, value) in
      mutableRequest.setValue(value, forHTTPHeaderField: key)
    }
    return mutableRequest
  }

  private func requestBody(_ body: [String: Any]) -> URLRequest {
    var mutableRequest = self
    mutableRequest.httpBody = body.percentEncoded()
    return mutableRequest
  }

  private static func makeURLComponents(for route: Routing) -> URLComponents? {
    var urlComponents = URLComponents(string: route.host + route.path)
    urlComponents?.queryItems = route.parameters.compactMap { key, value in
      URLQueryItem(name: key, value: value as? String)
    }
    return urlComponents
  }
}
