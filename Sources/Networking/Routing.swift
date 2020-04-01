//
//  Routing.swift
//  
//
//  Created by Gungor Basa on 4/1/20.
//

import Foundation

public protocol Routing {
  var host: String { get }
  var path: String { get }
  var headers: [String: String] { get }
  var parameters: [String: Any] { get }
  var body: [String: Any] { get }
  var method: HTTPMethod { get }
}
