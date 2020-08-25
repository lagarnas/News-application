//
//  News.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 24.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

struct News {
  let channelId: String
  let author: String?
  let date: Date
  let title: String
  let subtitle: String?
  let content: String?
  let url: URL?
  let urlToImage: URL?
  var isRead: Bool = false
  
  init?(article: ArticleResponse) {
    channelId = article.source?.id ?? "news"
    author = article.author
    date = article.publishedAt
    title = article.title
    subtitle = article.description
    content = article.content
    url = URL(string: article.url ?? "https://www.google.com/") 
    urlToImage = URL(string: article.urlToImage ?? "https://www.google.com/")
  }
}
