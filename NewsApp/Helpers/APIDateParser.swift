//
//  APIDateParser.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 12.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

final class APIDateParser {
  private let formatter = DateFormatter()
  
  init() {
    self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
  }
  
  func parseDate(_ string: String) -> Date {
    guard let simpleDate = formatter.date(from: string) else {
      print(DateError.invalidDateFormatForParsing.localizedDescription)
      return Date(timeIntervalSinceReferenceDate: -123456789.0)}
    return simpleDate
  }
}
