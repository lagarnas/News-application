//
//  DateError.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 01.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

enum DateError: String, Error {
  case invalidDateFormatForParsing = "Invalid date format for parsing date"
  case invalidLocalDate = "Invalid local date"
}

extension DateError: LocalizedError {
  var errorDescription: String? { return NSLocalizedString(rawValue, comment: "")}
}
