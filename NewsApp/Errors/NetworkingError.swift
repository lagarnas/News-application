//
//  NetworkingError.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 01.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

enum NetworkingError: String, Error {
  case invalideRequest = "error.invalideRequest"
  case invalideResponse = "error.invalidResponse"
  case internetConnectionFail = "error.notConnectedToInternet"
  case cannotFindHost = "error.errorCannotFindHost"
  case decodingError = "The given data was not valid JSON"
  case timeOut = "error.timeOut"
  case apiKeyInvalid = "Your API key is invalid or incorrect. Check your key, or go to https://newsapi.org to create a free API key."
  case notFound = "Not found resourse"
  case unknownError = "Unknown error"
}

extension NetworkingError: LocalizedError {
  var errorDescription: String? { return NSLocalizedString(rawValue, comment: "")}
}
