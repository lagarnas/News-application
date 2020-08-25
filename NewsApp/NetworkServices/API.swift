//
//  API.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 03.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

struct API {
  static let scheme = "https"
  static let host = "newsapi.org"
  
  //static let apiKey = "7a32de7bac2440fbab4c57ab90f10875"
  //static let apiKey = "d160d6dfab434e3b8c35d4d657439ced"
  static let apiKey = "3015ae5983164413bcf9292b536e3b32"
  //static let apiKey = "eb24d68eb5e74d058c00fb800fc85f12"
  //static let apiKey = "d5010246004442b69eec4fc674b9c70c"
  
  static let pathChannels = "/v2/sources"
  static let pathNewsOfChannels = "/v2/top-headlines"
  static let pathAllNews = "/v2/everything"
  
  enum QueryItemName: String {
    case sources = "sources"
    case q = "q"
    case apiKey = "apiKey"
    case pageSize = "pageSize"
  }
  
}
