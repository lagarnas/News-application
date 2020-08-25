//
//  extension.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 19.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

extension Date {
  
  func timeAgo() -> String {
    
    let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
    
    if let year = interval.year, year > 0       { return String.localizedStringWithFormat(NSLocalizedString("numberOfYears", comment: ""), year)}
    if let month = interval.month, month > 0    { return String.localizedStringWithFormat(NSLocalizedString("numberOfMonths", comment: ""), month)}
    if let day = interval.day, day > 0          { return String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: ""), day)}
    if let hour = interval.hour, hour > 0       { return String.localizedStringWithFormat(NSLocalizedString("numberOfHours", comment: ""), hour)}
    if let minute = interval.minute, minute > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfMinutes", comment: ""), minute)}
    else if let second = interval.second, second > 0 { return String.localizedStringWithFormat(NSLocalizedString("numberOfSeconds", comment: ""), second)}
    return NSLocalizedString("momentAgo", comment: "")
  }
}


