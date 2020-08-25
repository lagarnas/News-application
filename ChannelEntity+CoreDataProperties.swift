//
//  ChannelEntity+CoreDataProperties.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 18.08.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//
//

import Foundation
import CoreData


extension ChannelEntity {

    @NSManaged public var id: String
    @NSManaged public var isVisible: Bool
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var news: NSSet?

}

