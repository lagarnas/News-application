//
//  NewsChannelCell.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 17.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var contentLabel: UILabel!
  @IBOutlet private weak var imageOfNews: UIImageView!
  
  @IBOutlet private weak var unreadMark: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    unreadMark.layer.cornerRadius = unreadMark.frame.height / 2
  }
  
  func configure(author: String?,
                        date: String,
                        title: String,
                        subtitle: String?,
                        urlImage: URL?,
                        isRead: Bool
  ) {
    dateLabel.text = date
    titleLabel.text = title
    unreadMark.isHidden = isRead
    
    guard let subtitle = subtitle else { return }
    contentLabel.text = subtitle
    
    guard let author = author else {
      authorLabel.text = "~"
      return
    }
    let newString = cutString(str: author)
    authorLabel.text = NSURL(string: newString) != nil ? fileNameFrom(path: newString): author
        
    if urlImage?.absoluteString == "null"  || urlImage?.absoluteString == "" || urlImage == nil {
      imageOfNews.image = UIImage(systemName: "photo")
      
    } else {
      guard let urlImage1 = urlImage else { return }
      imageOfNews.kf.indicatorType = .activity
      imageOfNews.kf.setImage(with: urlImage1,
                              placeholder: UIImage(systemName: "photo"),
                              options: [.transition(.fade(0.7))],
                              progressBlock: nil)
    }
  }
}

extension NewsTableViewCell {
  private func fileNameFrom(path: String) -> String {
    NSString(string: NSString(string: path).deletingLastPathComponent).lastPathComponent.replacingOccurrences(of: "-", with: " ").capitalized
  }
  
  private func cutString(str: String) -> String{
    if let index = str.range(of: ",")?.lowerBound {
      let beforeEqualsTo = String(str.prefix(upTo: index))
      return beforeEqualsTo
    } else {
      return str
    }
  }
}


