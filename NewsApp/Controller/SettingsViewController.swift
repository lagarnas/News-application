//
//  ViewController.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 27.02.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import CoreData

final class SettingsViewController: UIViewController {
  
  //MARK: - @IBOutlets
  @IBOutlet private weak var tableView: UITableView!
  
  //MARK: - Variables
  private var channelModel: ChannelModel!
  
  private var fetchedResultsController = PersistenceService.shared.setupChannelsFetchedResultController()
  
  //MARK: - @IBActions
  @IBAction private func closeButton(_ sender: UIBarButtonItem) {
    //сохранить изменения перед закрытием
    
    dismiss(animated: true, completion: nil)
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initialization()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchData()
  }
  
  //MARK: - functions

  private func fetchData() {
    try! fetchedResultsController.performFetch()
    tableView.reloadData()
  }
  
  // MARK: - Public functions
  func set(model: ChannelModel) {
    self.channelModel = model
  }
  
  // MARK: - Private functions
  private func initialization() {
    tableView.register(UINib(nibName: SettingsTableViewCell.nibName,
                             bundle: nil),
                       forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
    self.title = NSLocalizedString("settingsVC.title", comment: "")
  }
}

//MARK: - Extensions
extension SettingsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else { return 0 }
    return sections[section].numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueCell(SettingsTableViewCell.self, for: indexPath)
    let channel = fetchedResultsController.object(at: indexPath)
    cell.configure(channel: channel)
    
    cell.delegate = self
    
    return cell
  }
}

//MARK: - ChannelCellDelegate
extension SettingsViewController: SettingsTableViewCellDelegate {
  func settingsTableViewCell(_ settingsTableViewCell: SettingsTableViewCell, id: String, didToggleSwitch isVisible: Bool) {
    channelModel.updateVisible(for: id, isVisible: isVisible) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(_):
        self.tableView.reloadData()
      case .failure(let error):
        ToastService.showToast(view: self.view, message: error.localizedDescription)
      }
    }
  }
}

