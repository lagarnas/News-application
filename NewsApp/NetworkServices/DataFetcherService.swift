//
//  NetworkDataFetcher.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 16.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

final class DataFetcherService {
  
  //MARK: - Singleton()
  static let shared = DataFetcherService()

  let dataFetcher: DataFetcher
  let networking: Networking
  
  private let callbackQueue = DispatchQueue.main
  
  init(dataFetcher: DataFetcher = NetworkDataFetcher(), networking: Networking = NetworkService()) {
    self.dataFetcher = dataFetcher
    self.networking = networking
  }
  
  //MARK: - fetchChannels()
  func fetchChannels(completion: @escaping (Result<[SourceResponse], Error>) -> Void) {
    
    let request = URLRequest(url: networking.urlPath(API.pathChannels, []))
    
    dataFetcher.fetchJSONData(from: request, type: APIResponse<[SourceResponse]>.self, completion: { result in
      
      switch result {
      case .success(let channels):
        self.callbackQueue.async {
          completion(.success(channels.payload ?? []))
        }
      case .failure(let error):
        self.callbackQueue.async {
          completion(.failure(error))
        }
      }
    })
  }
  
  //MARK: - fetchLastNews()
  func fetchLastNews(for channelId: String, completion: @escaping (Result<[ArticleResponse], Error>) -> Void) {
    
    let request = URLRequest(url: networking.urlPath(API.pathNewsOfChannels,
                                                         [URLQueryItem(name: API.QueryItemName.sources.rawValue,value: channelId),
                                                          URLQueryItem(name: API.QueryItemName.pageSize.rawValue, value: "1")]))
    
    dataFetcher.fetchJSONData(from: request, type: APIResponse<[ArticleResponse]>.self, completion: { result in
      
      switch result {
      case .success(let news):
        self.callbackQueue.async {
          completion(.success(news.payload ?? []))
        }
      case .failure(let error):
        self.callbackQueue.async {
          completion(.failure(error))
        }
      }
    })
  }
  
  //MARK: - fetchNews()
  func fetchAllNews(for channelIds: [String], completion: @escaping (Result<[ArticleResponse], Error>) -> Void) {
    
    let request = URLRequest(url: networking.urlPath(API.pathNewsOfChannels, [URLQueryItem(name: API.QueryItemName.sources.rawValue,
                                                                                               value:  channelIds.minimalDescription)]))
    
    dataFetcher.fetchJSONData(from: request, type: APIResponse<[ArticleResponse]>.self, completion: { result in
      
      switch result {
      case .success(let news):
         self.callbackQueue.async {
          completion(.success(news.payload ?? []))
        }
      case .failure(let error):
         self.callbackQueue.async {
          completion(.failure(error))
        }
      }
    })
  }
  //MARK: - fetchAllNews()
  func fetchFilteredNews(filter: String, completion: @escaping (Result<[ArticleResponse], Error>) -> Void) {
    
    let request = URLRequest(url: networking.urlPath(API.pathAllNews,
                                                         [URLQueryItem(name: API.QueryItemName.q.rawValue,
                                                                       value: filter)]))
    
    dataFetcher.fetchJSONData(from: request, type: APIResponse<[ArticleResponse]>.self, completion: { result in
      
      switch result {
      case .success(let news):
         self.callbackQueue.async {
          completion(.success(news.payload ?? []))
        }
      case .failure(let error):
         self.callbackQueue.async {
          completion(.failure(error))
        }
      }
    })
  }
}
