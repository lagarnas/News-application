//
//  APIResponse.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 23.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

struct APIResponse<Payload> {
  let status:  String
  var message: String?
  var payload: Payload?
}

extension APIResponse: Decodable where Payload: Decodable {
  
  enum APIParsingError: Error {
    case unknownPayloadType
  }
  
  enum CodingKeys: String, CodingKey {
    case status
    case code
    case message
    case sources
    case articles
    case error
  }
  
  init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: CodingKeys.self)
    
    self.status = try c.decode(String.self, forKey: .status)
    
    if status == "ok" {
      self.payload = try c.decode(Payload.self, forKey: try Self.payloadField())
    }
    else {
      self.message = try c.decode(String.self, forKey: .message)
    }
  }
  
  private static func payloadField() throws -> CodingKeys {
    switch Payload.self {
    case is [SourceResponse].Type:
      return .sources
    case is [ArticleResponse].Type:
      return .articles
    default:
      throw APIParsingError.unknownPayloadType
    }
  }
}

