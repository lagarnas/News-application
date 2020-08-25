//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 16.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

final class NetworkManager {
  
  //MARK: - Singleton()
  public static let shared = NetworkManager()
  private init() {}
  
  private let session = URLSession.shared
  private let dataParser = NetworkDataParser.shared
  
  //MARK: - urlPath()
  public func urlPath(_ path: String, _ queryItems: [URLQueryItem]) -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = API.scheme
    urlComponents.host = API.host
    urlComponents.path = path
    urlComponents.queryItems = queryItems + [URLQueryItem(name: API.QueryItemName.apiKey.rawValue,
                                                          value: API.apiKey)]
    
    return urlComponents.url!
  }
  
  //MARK: - load()
  public func load<Response: Decodable>(request: URLRequest,
                                         type: Response.Type,
                                         completion: @escaping (Result<Response, NetworkingError>) -> Void ) {
    
    let task = session.dataTask(with: request) { data, response, error in
      
      if let error = error as NSError? {
        if error.domain == NSURLErrorDomain {
          switch error.code {
          case NSURLErrorCancelled:
            print(error.localizedDescription)
          case NSURLErrorUnknown:
            print(error.localizedDescription)
          case NSURLErrorCannotFindHost:
            completion(.failure(.cannotFindHost))
          case NSURLErrorNotConnectedToInternet:
            completion(.failure(.internetConnectionFail))
          case NSURLErrorTimedOut:
            completion(.failure(.timeOut))
          case NSURLErrorCannotConnectToHost:
            print(NetworkingError.apiKeyInvalid.localizedDescription)
          default:
            fatalError("An unexpected error occured \n\(error.code) - \(error.domain) - \(error.localizedDescription)")
          }
        }
      }
      
      guard let response = response as? HTTPURLResponse else { return }
      switch response.statusCode {
      case 400:
        completion(.failure(.invalideRequest))
      case 429:
        print(NetworkingError.apiKeyInvalid.localizedDescription)
      case 404:
        print(NetworkingError.notFound.localizedDescription)
      default:
        break
      }
      
      guard let data = data else { return }
      
      completion(.success(self.dataParser.parseJSON(data: data, type: type)))
    }
    task.resume()
  }
  
  deinit {
    print("deinit NetworkManager")
  }
}


