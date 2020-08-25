//
//  ChannelNetworkModel.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 12.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

final class ChannelNetworkModel {
  
  public static let shared = ChannelNetworkModel()
  private let networking = DataFetcherService.shared
  private init() {}
  
  //MARK: - Public functions
  func loadChannels(completion: @escaping (Result<[Channel], Error>) -> Void) {
    
    networking.fetchChannels(completion: { result in
      switch result {
      case .success(let channels):

        completion(.success(channels.getChannels()))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }
  
  func loadLastNews(channelId: String, completion: @escaping (Result<[News], Error>) -> Void) {
    
    networking.fetchLastNews(for: channelId){ result in
      switch result {
      case .success(_):
        completion(result.map { $0.getNews() })
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func loadAllNews(visibleChannelsIds: [String], completion: @escaping (Result<[News], Error>) -> Void) {
    
    networking.fetchAllNews(for: visibleChannelsIds) { result in
      
      switch result {
      case .success(let news):
        completion(.success(news.getNews()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func loadFilteredNews(filter: String, completion: @escaping (Result<[News], Error>) -> Void) {
    
    networking.fetchFilteredNews(filter: filter, completion: { result in
      switch result {
      case .success(let news):
        completion(.success(news.getNews()))
      case .failure(let error):
        completion(.failure(error))
      }
    })
  }
}
