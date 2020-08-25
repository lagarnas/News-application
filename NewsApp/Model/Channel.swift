//
//  Source.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 18.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

struct Channel {
  let id: String
  var title: String
  let subtitle: String?
  var isVisible: Bool = false
  
  init?(source: SourceResponse) {
    id = source.id!
    title = source.name!
    subtitle = source.description
  }
}


