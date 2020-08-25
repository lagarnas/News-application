//
//  ToastService.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 30.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import Toast_Swift

final class ToastService {
  
  class func showToast(view: UIView, message: String) {
    
    view.makeToast(message, duration: 2,
                   point: CGPoint(x: view.center.x, y: view.center.y),
                   title: nil, image: nil,
                   style: ToastManager.shared.style,
                   completion: nil)
  }
}
