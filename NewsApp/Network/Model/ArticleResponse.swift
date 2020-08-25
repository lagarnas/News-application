//
//  ArticlesModel.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 16.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

struct ArticleResponse: Codable {
  let author: String?
  let content: String?
  let description: String?
  let publishedAt: Date
  let source: SourceResponse?
  let title: String
  let url: String?
  let urlToImage: String?
}

