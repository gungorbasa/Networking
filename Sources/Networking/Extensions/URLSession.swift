//
//  URLSessionError.swift
//  
//
//  Created by Gungor Basa on 4/1/20.
//

import Foundation

public enum URLSessionError: LocalizedError {
  case unknown, urlError

  public var errorDescription: String? {
    switch self {
    case .urlError:
      return "Cannot convert to url."
    default:
      return "Unknown error is occured during network call."
    }
  }
}

extension URLSession {
  func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
    return dataTask(with: url) { [weak self] (data, response, error) in
      guard let self = self else { return }
      result(self.createResult(data: data, response: response, error: error))
    }
  }

  func dataTask(
    with request: URLRequest,
    result: @escaping (Result<(URLResponse, Data), Error>) -> Void
  ) -> URLSessionDataTask {
    return dataTask(with: request) { [weak self] (data, response, error) in
      guard let self = self else { return }
      result(self.createResult(data: data, response: response, error: error))
    }
  }

  private func createResult(data: Data?, response: URLResponse?, error: Error?) -> Result<(URLResponse, Data), Error> {
    if let error = error {
      return .failure(error)
    }
    guard let response = response, let data = data else {
      return .failure(URLSessionError.unknown)
    }
    return .success((response, data))
  }
}
