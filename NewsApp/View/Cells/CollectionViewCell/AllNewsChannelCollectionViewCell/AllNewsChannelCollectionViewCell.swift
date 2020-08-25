//
//  AllNewsCell.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 26.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import Kingfisher

final class AllNewsChannelCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subTitleLabel: UILabel!
  @IBOutlet private weak var lastNewsImageView: UIImageView!
  @IBOutlet private weak var unreadNewsLabel: UILabel!
  
  func configure(title: String = "All News", subtitle: String, urlImage: URL?, countOfUnreadNews: Int) {
    
    self.titleLabel.text = title
    self.subTitleLabel.text = subtitle
    
    if countOfUnreadNews > 0 {
      self.unreadNewsLabel.isHidden = false
      self.unreadNewsLabel.text = String.localizedStringWithFormat(NSLocalizedString("unreadNewsLabel", comment: ""), countOfUnreadNews)
      
    } else {
      unreadNewsLabel.isHidden = true
    }
    
    if urlImage?.absoluteString == "null" || urlImage?.absoluteString == "" || urlImage == nil {
      lastNewsImageView.image = UIImage(systemName: "photo")
    } else {
      self.lastNewsImageView.kf.indicatorType = .activity
      let resource = ImageResource(downloadURL: urlImage!)
      let placeHolder = UIImage(systemName: "photo")
      self.lastNewsImageView.kf.setImage(with: resource,
                                         placeholder: placeHolder,
                                         options: [.transition(.fade(0.7))],
                                         progressBlock: nil) { (result) in
                                          self.hande(result)
      }
    }
  }
  
  private func hande(_ result: Result<RetrieveImageResult, KingfisherError>) {
    switch result {
    case .success(let  retriveImageResult):
      let image = retriveImageResult.image
      let cacheType = retriveImageResult.cacheType
      let source = retriveImageResult.source
      let originalSource = retriveImageResult.originalSource
      _ = """
      Image size:
      \(image.size)
      
      Cache:
      \(cacheType)
      
      Source:
      \(source)
      
      Original Source:
      \(originalSource)
      """
    case .failure(_):
      
      print(LoadImageError.failToSetImage.localizedDescription)
    }
  }
}
