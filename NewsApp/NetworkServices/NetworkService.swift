//
//  NetworkService.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 16.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

protocol Networking {
  
  func urlPath(_ path: String, _ queryItems: [URLQueryItem]) -> URL
  func request(request: URLRequest, completion: @escaping (Result<Data, NetworkingError>) -> Void)
}

final class NetworkService: Networking {
  
  //MARK: - urlPath()
  func urlPath(_ path: String, _ queryItems: [URLQueryItem]) -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = API.scheme
    urlComponents.host = API.host
    urlComponents.path = path
    urlComponents.queryItems = queryItems + [URLQueryItem(name: API.QueryItemName.apiKey.rawValue,
                                                          value: API.apiKey)]
    
    return urlComponents.url!
  }
  
  func request(request: URLRequest, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
    
    let task = createDataTask(from: request, completion: completion)
    task.resume()
  }
  
  private func createDataTask(from request: URLRequest, completion: @escaping (Result<Data, NetworkingError>) -> Void) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: request) { (data, response, error) in
      let result = self.resultFromServerResponse(data, response, error)
      completion(result)
    }
  }
  
  private func resultFromServerResponse(_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Result<Data, NetworkingError> {
    if let error = error as NSError? {
      if error.domain == NSURLErrorDomain {
        switch error.code {
        case NSURLErrorCancelled:
          print(error.localizedDescription)
        case NSURLErrorUnknown:
          print(error.localizedDescription)
        case NSURLErrorCannotFindHost:
         return .failure(.cannotFindHost)
        case NSURLErrorNotConnectedToInternet:
          return .failure(.internetConnectionFail)
        case NSURLErrorTimedOut:
          return.failure(.timeOut)
        case NSURLErrorCannotConnectToHost:
          return .failure(.apiKeyInvalid)
        default:
          fatalError("An unexpected error occured \n\(error.code) - \(error.domain) - \(error.localizedDescription)")
        }
      }
    }
    
    if let response = response as? HTTPURLResponse {
      switch response.statusCode {
      case 400:
        return .failure(.invalideRequest)
      case 429:
        return .failure(.apiKeyInvalid)
      case 404:
        return .failure(.notFound)
      default:
        break
      }
    }
    
    if let data = data {
      return .success(data)
    }
    return .failure(.unknownError)
  }
}
