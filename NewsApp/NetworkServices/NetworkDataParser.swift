//
//  NetworkDataParser.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 15.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

protocol DataParser {
  
  func parseJSON<Response: Decodable>(data: Data,
                                      type: Response.Type) -> Response
}

final class NetworkDataParser: DataParser {
  
  private let decoder = JSONDecoder()
  private let dateParser = APIDateParser()
  private let dateLocalConverter = DateLocalConverter()
  
  func parseJSON<Response: Decodable>(data: Data,
                                              type: Response.Type) -> Response {
    
    do {
      decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        let localDateStr = self.dateLocalConverter.convertToLocalDate(dateToConvert: dateString)
        return self.dateParser.parseDate(localDateStr)
      })
      
      let response = try decoder.decode(Response.self, from: data)
      
      return response
      
    } catch let error {
      print(error.localizedDescription)
    }
    
    return Response.self as! Response
  }
}
