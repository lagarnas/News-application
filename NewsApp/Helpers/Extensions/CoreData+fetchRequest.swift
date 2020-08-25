//
//  CoreData+fetchRequest.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 13.08.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
  static func fetchingRequest<T>() -> NSFetchRequest<T>
  {
    NSFetchRequest<T>(entityName: self.entity().name!)
  }
}
