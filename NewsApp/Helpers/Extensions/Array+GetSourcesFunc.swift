//
//  Array+.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 22.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

extension Array where Element == SourceResponse {
  
  func getChannels() -> [Channel] {
    self.map { (source) -> Channel in
      Channel(source: source)!
    }
  }
}

extension Array where Element == ArticleResponse {
  
  func getNews() -> [News] {
    self.map { (article) -> News in
      News(article: article)!
    }
  }
}

extension Array where Element == String {
  var minimalDescription: String {
    let str = map { "\($0)" }.joined(separator: ",")
    return str
  }
}

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}

