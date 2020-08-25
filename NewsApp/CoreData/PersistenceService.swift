//
//  PersistenceSevice.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 09.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceService {
  
  static let shared = PersistenceService()
  private init() {
    privateMOC.parent = self.context
  }
  var context: NSManagedObjectContext { persistentContainer.viewContext }
  
  private let privateMOC: NSManagedObjectContext = {
    
    let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    return moc
    
  }()
  

  public lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "NewsModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
    
    return container
  }()
  
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
        print("Saved sucessfully")
        
      } catch let error {
        print("Could not save. \(error), \(error.localizedDescription)")
      }
    }
  }
  
  func setupChannelsFetchedResultController() -> NSFetchedResultsController<ChannelEntity> {
    let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchingRequest()
    let sortDescriptor = NSSortDescriptor(keyPath: \ChannelEntity.id, ascending: true)
    request.sortDescriptors = [sortDescriptor]
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return frc
  }
  
  func setupNewsFetchedResultController(channel: ChannelEntity) -> NSFetchedResultsController<NewsEntity> {
    let request: NSFetchRequest<NewsEntity> = NewsEntity.fetchingRequest()
    request.predicate = NSPredicate(format: "channel == %@", channel)
    let sortDescriptor = NSSortDescriptor(keyPath: \NewsEntity.date, ascending: false)
    request.sortDescriptors = [sortDescriptor]
    
    
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return frc
  }
  
  func setupNewsFetchedResultController() -> NSFetchedResultsController<NewsEntity> {
    let request: NSFetchRequest<NewsEntity> = NewsEntity.fetchingRequest()
    request.predicate = NSPredicate(format: "\(#keyPath(NewsEntity.channel.isVisible)) == TRUE")
    let sortDescriptor = NSSortDescriptor(keyPath: \NewsEntity.date, ascending: false)
    request.sortDescriptors = [sortDescriptor]
    
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    return frc
  }
  
}

extension PersistenceService {
  
  func saveChannelsData(channels: [Channel]) {
    self.privateMOC.perform {
      let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchingRequest()
      let savedChannels = try! self.privateMOC.fetch(request)
      
      channels.forEach { channel in
        guard !savedChannels.map({($0 as AnyObject).id}).contains(channel.id) else { return }
        
        let dbChannel = ChannelEntity(context: self.privateMOC)
        dbChannel.id = channel.id
        dbChannel.title = channel.title
        dbChannel.subtitle = channel.subtitle
        dbChannel.isVisible = channel.isVisible
      }
      do {
        try self.privateMOC.save()
      } catch {
        print("Could not synchronize data", error.localizedDescription)
      }
    }
  }
  
  func saveNewsData(channel: ChannelEntity, news: [News]) {

    let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchingRequest()
    request.predicate = NSPredicate(format: "id == %@", channel.id)
    let savedChannel = try! self.context.fetch(request).first
    let savedNews = savedChannel?.news?.allObjects as? [NewsEntity]
    
      news.forEach { news in
        guard !(savedNews?.map({$0.date}).contains(news.date))! else {
          let singleSavedNews = savedNews?.first {$0.date == news.date}
          singleSavedNews?.author = news.author
          singleSavedNews?.title = news.title
          singleSavedNews?.content = news.content
          singleSavedNews?.url = news.url
          singleSavedNews?.urlToImage = news.urlToImage
          return
        }
        let dbNews = NewsEntity(context: self.context)

        dbNews.channelId = news.channelId
        dbNews.author = news.author
        dbNews.title = news.title
        dbNews.subtitle = news.subtitle
        dbNews.content = news.content
        dbNews.date = news.date
        dbNews.url = news.url
        dbNews.urlToImage = news.urlToImage
        dbNews.isRead = news.isRead
        
        let savedNewsSet = savedChannel?.news?.mutableCopy() as? NSMutableSet
        savedNewsSet?.add(dbNews)
        savedChannel?.news = savedNewsSet
      }
    self.saveContext()
  }
  
  
  func fetchChannelsData() -> [ChannelEntity] {
    var savedChannels = [ChannelEntity]()
    let request: NSFetchRequest<ChannelEntity> = NSFetchRequest<ChannelEntity>(entityName: "ChannelEntity")
    let sortDescriptor = NSSortDescriptor(keyPath: \ChannelEntity.id, ascending: true)
    request.sortDescriptors = [sortDescriptor]
    savedChannels = try! context.fetch(request)
    return savedChannels
  }
  
  func fetchVisibleNewsData() -> [NewsEntity] {
    var savedNews = [NewsEntity]()
    let request = NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    request.predicate = NSPredicate(format: "\(#keyPath(NewsEntity.channel.isVisible)) == TRUE")
    let sortDescriptor = NSSortDescriptor(keyPath: \NewsEntity.date, ascending: false)
    request.sortDescriptors = [sortDescriptor]
    savedNews = try! context.fetch(request)
    return savedNews
  }
}

