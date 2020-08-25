//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 16.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

protocol DataFetcher {
  
  func fetchJSONData<Response: Decodable>(from request: URLRequest, type: Response.Type, completion: @escaping (Result<Response, NetworkingError>) -> Void)
}

final class NetworkDataFetcher: DataFetcher {
  
  let dataParser: DataParser
  let networking: Networking
  
  init(dataParser: DataParser = NetworkDataParser(), networking: Networking = NetworkService()) {
    self.dataParser = dataParser
    self.networking = networking
  }
  
  
  //MARK: - fetchJSONData()
  func fetchJSONData<Response: Decodable>(from request: URLRequest,
                                        type: Response.Type,
                                        completion: @escaping (Result<Response, NetworkingError>) -> Void) {
    
    networking.request(request: request) { result in
      switch result {
      case .success(let data):
        completion(.success(self.dataParser.parseJSON(data: data, type: type)))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}


