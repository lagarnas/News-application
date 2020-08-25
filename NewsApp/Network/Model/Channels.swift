//
//  SourceModel.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 16.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

struct Channels: Codable {
    let status: String
    let sources: [Source]
}
