//
//  NewsEntity+CoreDataProperties.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 13.08.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var channelId: String?
    @NSManaged public var content: String?
    @NSManaged public var date: Date
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var urlToImage: URL?
    @NSManaged public var isRead: Bool
    @NSManaged public var channel: ChannelEntity?

}
