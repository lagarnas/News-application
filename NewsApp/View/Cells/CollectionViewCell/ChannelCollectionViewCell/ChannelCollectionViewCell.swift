//
//  ChannelCollectionViewCell.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 08.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import Kingfisher

final class ChannelCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subTitleLabel: UILabel!
  @IBOutlet private weak var lastNewsImageView: UIImageView!
  
  @IBOutlet private weak var unreadNewsLabel: UILabel!
  
  func configure(title: String, subtitle: String, urlImage: URL?, countOfUnreadNews: Int) {
    self.titleLabel.text = title
    self.subTitleLabel.text = subtitle
    if countOfUnreadNews > 0 {
      unreadNewsLabel.isHidden = false
      self.unreadNewsLabel.text = String.localizedStringWithFormat(NSLocalizedString("unreadNewsLabel", comment: ""), countOfUnreadNews)
    } else {
      unreadNewsLabel.isHidden = true
    }
    
    
    if urlImage?.absoluteString == "null"  || urlImage?.absoluteString == "" || urlImage == nil {
      lastNewsImageView.image = UIImage(systemName: "photo")
      
    } else {
      let placeHolder = UIImage(systemName: "photo")
      self.lastNewsImageView.kf.indicatorType = .activity
      self.lastNewsImageView.kf.setImage(with: urlImage,
                                         placeholder: placeHolder,
                                         options: [.transition(.fade(0.7))],
                                         progressBlock: nil)
    }
  }
}
