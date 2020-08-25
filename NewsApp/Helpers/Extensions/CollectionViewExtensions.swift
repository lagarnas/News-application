//
//  UICollectionViewDelegateFlowLayout.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 23.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Flow Layout variables
private let itemsPerRow: CGFloat = 2
private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

//MARK: - UICollectionViewDelegateFlowLayout
extension ChannelsViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
    let paddingWidthForFirstCell = sectionInsets.left * itemsPerRow
    let availableWidth = collectionView.frame.width - paddingWidth
    let availableWidthForFirstCell = collectionView.frame.width - paddingWidthForFirstCell
    
    let itemWidth: CGFloat
    let itemSize: CGSize
    if indexPath.item == 0 {
      itemWidth = availableWidthForFirstCell
      itemSize = CGSize(width: itemWidth, height: itemWidth/2)
    } else {
      itemWidth = availableWidth / itemsPerRow
      itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    return itemSize
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    
    sectionInsets
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
    sectionInsets.left
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
    sectionInsets.left
  }
}

extension UICollectionView {
  
  func dequeueCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Unable to dequeue \(T.self)")
    }
    return cell
  }
}
