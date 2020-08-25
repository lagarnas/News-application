//
//  SourceModel.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 17.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.

import Foundation
import CoreData

//MARK: - Protocols
protocol ChannelModelDelegate: class {
  func channelModelDidUpdateChannels(_ channelModel: ChannelModel)
  func channelModelDidLoadNews(_ channelModel: ChannelModel)
}

final class ChannelModel {
  
  //MARK: - Variables
  private let persistence = PersistenceService.shared
  //MARK: - Delegate
  weak var delegate: ChannelModelDelegate?
  
  //MARK: - Public functions
  //Обновление каналов
  func loadChannels(completion: @escaping (Result<[ChannelEntity], Error>) -> Void) {
    
    ChannelNetworkModel.shared.loadChannels { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let channels):
        //core data save channels
        self.persistence.saveChannelsData(channels: channels)
      case .failure(let error):
        completion(.failure(error))
      }
      self.delegate?.channelModelDidUpdateChannels(self)
    }
  }
  
  //Обновление всех новостей для конкретного канала
  func updateAllNewsFor(channel: ChannelEntity, completion: @escaping (Result<[News], Error>) -> Void) {
    
    ChannelNetworkModel.shared.loadAllNews(visibleChannelsIds: [channel.id]) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let news):
        self.persistence.saveNewsData(channel: channel, news: news)
        completion(.success(news))
      case .failure(let error):
        completion(.failure(error))
      }
      self.delegate?.channelModelDidUpdateChannels(self)
    }
  }
  
  //Обновление видимости канала
  func updateVisible(for channelId: String, isVisible: Bool, completion: @escaping (Result<[News], Error>) -> Void) {
    var channel: ChannelEntity?
    let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchingRequest()
    request.predicate = NSPredicate(format: "id == %@", channelId)
    channel = try! persistence.context.fetch(request).first
    //сохраняем видимость для канала
    channel?.isVisible = isVisible
    
    updateLastNewsFor(channel: channel!) { result in
      switch result {
      case .success(let news):
        completion(.success(news))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  //Обновление прочитанности новости
  func readNews(_ news: NewsEntity) {
    let news = news
    news.isRead = true
    persistence.saveContext()
    self.delegate?.channelModelDidUpdateChannels(self)
  }
  
  func readAllNews(in channel: ChannelEntity) {
    let request = NSBatchUpdateRequest(entityName: "NewsEntity")
    request.predicate = NSPredicate(format: "channel == %@", channel)
    request.propertiesToUpdate = ["isRead": NSNumber(value: true)]
    request.resultType = .updatedObjectIDsResultType
    
    do {
      let result = try persistence.context.execute(request) as? NSBatchUpdateResult
      let objectIDArray = result?.result as? [NSManagedObjectID]
      let changes = [NSUpdatedObjectsKey : objectIDArray]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [persistence.context])
    } catch  {
      print(error.localizedDescription)
    }
    self.delegate?.channelModelDidUpdateChannels(self)
  }
  
  func readAllNews() {
    let request = NSBatchUpdateRequest(entityName: "NewsEntity")
    request.propertiesToUpdate = ["isRead": NSNumber(value: true)]
    request.resultType = .updatedObjectIDsResultType
    
    do {
      let result = try persistence.context.execute(request) as? NSBatchUpdateResult
      let objectIDArray = result?.result as? [NSManagedObjectID]
      let changes = [NSUpdatedObjectsKey : objectIDArray]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [persistence.context])
    } catch  {
      print(error.localizedDescription)
    }
    self.delegate?.channelModelDidUpdateChannels(self)
    
  }
  
  
  //Обновление последней новости для конкретного канала
  func updateLastNewsFor(channel: ChannelEntity, completion: @escaping (Result<[News], Error>) -> Void) {
    ChannelNetworkModel.shared.loadLastNews(channelId: channel.id) { [weak self]  result in
      guard let self = self else { return }
      switch result {
      case .success(let news):
        completion(.success(news))
        self.persistence.saveNewsData(channel: channel, news: news)
        
      case .failure(let error):
        completion(.failure(error))
      }
      self.delegate?.channelModelDidUpdateChannels(self)
    }
  }
}


extension ChannelModel {
  
  func getSavedChannels() -> [ChannelEntity] {
    self.persistence.fetchChannelsData()
  }
  
  func getVisibleChannels() -> [ChannelEntity] {
    getSavedChannels().filter{ $0.isVisible }
  }
  
  func getSavedNewsForAllNewsChannel() -> [NewsEntity] {
    let newsOfVisibleChannels = persistence.fetchVisibleNewsData()
    return newsOfVisibleChannels
  }
  
  func getLastNewsFor(channel: ChannelEntity) -> NewsEntity {
    ((channel.news?.allObjects as? [NewsEntity])?.sorted(by: { (n1, n2) -> Bool in
      n1.date > n2.date
    }).first)!
  }
  
  
  func getLastNewsForAllNewsChannel() -> NewsEntity? {
    getSavedNewsForAllNewsChannel().first
  }
  
  func getUnreadNewsCount() -> Int {
    var count = 0
    getVisibleChannels().forEach { (channel) in
      count += getUnreadNewsCountFor(channel: channel)
    }
    return count
  }
  
  func getUnreadNewsCountFor(channel: ChannelEntity) -> Int {
    channel.news?.filter { ($0 as AnyObject).isRead == false }.count ?? 0
  }
}
