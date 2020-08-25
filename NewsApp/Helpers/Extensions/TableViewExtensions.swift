//
//  TableViewExtensions.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 14.07.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit

extension UITableView {
  
  func dequeueCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Unable to dequeue \(T.self)")
    }
    return cell
  }
}
