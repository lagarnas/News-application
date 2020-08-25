//
//  DateLocalConverter.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 30.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

final class DateLocalConverter {
  
  let simpleDateFormatter = DateFormatter()
  let dateFormatterWithMiliseconds = DateFormatter()
  
  func convertToLocalDate(dateToConvert: String)-> String {
    simpleDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatterWithMiliseconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ"
    
    if let converDate = simpleDateFormatter.date(from: dateToConvert) {
      simpleDateFormatter.timeZone = TimeZone.current
      simpleDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      let localDateStr = simpleDateFormatter.string(from: converDate)
      return localDateStr
    } else if let converDate = dateFormatterWithMiliseconds.date(from: dateToConvert) {
      dateFormatterWithMiliseconds.timeZone = TimeZone.current
      dateFormatterWithMiliseconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      let localDateStr = dateFormatterWithMiliseconds.string(from: converDate)
      return localDateStr
    }
    return DateError.invalidLocalDate.localizedDescription
  }
}
