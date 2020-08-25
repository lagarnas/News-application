//
//  LoadImageError.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 01.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

enum LoadImageError: String, Error {
  case failToSetImage = "Failure to setImage Retrieving resource succeeded, but this source is not the one currently expected"
}

extension LoadImageError: LocalizedError {
  var errorDescription: String? { return NSLocalizedString(rawValue, comment: "")}
}
