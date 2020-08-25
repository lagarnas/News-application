//
//  ChannelCell.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 02.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit

//MARK: - Protocol
protocol SettingsTableViewCellDelegate: class {
  func settingsTableViewCell(_ settingsTableViewCell: SettingsTableViewCell, id: String, didToggleSwitch isVisible: Bool)
}

final class SettingsTableViewCell: UITableViewCell {
  
  //MARK: - Outlets
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var pushSwitch: UISwitch!
  
  //MARK: Delegate
  weak var delegate: SettingsTableViewCellDelegate?
  
  //MARK: - Private Value
  private var channel: ChannelEntity?
  
  //MARK: - LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    initialization()
  }
  
  // MARK: - Private functions
  private func initialization() {
    pushSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
  }
  
  @objc private func switchChanged(_ sender: UISwitch) {
    if let id = channel?.id {
      delegate?.settingsTableViewCell(self, id: id, didToggleSwitch: sender.isOn)
    }
  }
  
  //MARK: - Function
  func configure(channel: ChannelEntity) {
    self.channel = channel
    titleLabel.text = channel.title
    descriptionLabel.text = channel.subtitle
    pushSwitch.isOn = channel.isVisible
  }
}

//MARK: - extensions
extension UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

