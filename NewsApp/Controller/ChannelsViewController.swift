//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 08.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit

final class ChannelsViewController: UIViewController {
  // MARK: - @IBOutlets
  @IBOutlet private weak var channelsCollectionView: UICollectionView!
  @IBOutlet private weak var messageLabel: UILabel!
  
  // MARK: - Variables
  private let channelModel = ChannelModel()
  private var cells : [CellData] = []
  
  private enum CellData {
    case allNewsChannel
    case channel(ChannelEntity)
  }
  
  private var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    return refreshControl
  }()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.title = NSLocalizedString("news.title", comment: "")
    self.navigationController?.tabBarItem.title = NSLocalizedString("news.tabBarItem", comment: "")
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.messageLabel.text = NSLocalizedString("news.messageLabel", comment: "")
    initialization()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    refresh(sender: refreshControl)
  }
  
  // MARK: - Private functions
  private func initialization() {
    channelsCollectionView.refreshControl = refreshControl
    channelModel.delegate = self
    loadChannels()
  }
  
  
  private func loadChannels() {
    channelModel.loadChannels { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(_):
        self.refreshControl.endRefreshing()
      case .failure(let error):
        ToastService.showToast(view: self.view, message: error.localizedDescription)
        self.refreshControl.endRefreshing()
      }
    }
  }

  @objc private func refresh(sender: UIRefreshControl) {

    channelModel.getVisibleChannels().forEach {
      channelModel.updateLastNewsFor(channel: $0) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(_):
          self.refreshControl.endRefreshing()
        case .failure(let error):
          ToastService.showToast(view: self.view, message: error.localizedDescription)
          self.refreshControl.endRefreshing()
        }
      }
    }
  }
  
  //MARK: - override functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    switch segue.identifier {
    case "toSettingsChannels":
      guard
        let nc = segue.destination as? UINavigationController,
        let vc = nc.viewControllers.first as? SettingsViewController
        else { return }
      vc.set(model: channelModel)
      
    case "toNews":
      guard self.channelsCollectionView.indexPathsForSelectedItems != nil else { return }
      guard let newsVC = segue.destination as? NewsViewController else { return }
      let indexPaths = self.channelsCollectionView.indexPathsForSelectedItems
      let indexPath = indexPaths![0] as NSIndexPath
      
      switch cells[indexPath.item] {
      case .channel(let channel):
        newsVC.set(mode: .channel(channel), channelModel: channelModel, title: channel.title ?? "")
      case .allNewsChannel:
        newsVC.set(mode: .channelOfAllNews, channelModel: channelModel, title: NSLocalizedString("news.titleCell.allNews", comment: ""))
      }
    default:
      break
    }
  }
}

//MARK: - ChannelModelDelegate
extension ChannelsViewController: ChannelModelDelegate {
  func channelModelDidLoadNews(_ channelModel: ChannelModel) {
    self.refreshControl.endRefreshing()
  }
  
  func channelModelDidUpdateChannels(_ channelModel: ChannelModel) {
    self.messageLabel.isHidden = !channelModel.getVisibleChannels().isEmpty
    self.refreshControl.endRefreshing()
    self.channelsCollectionView.reloadData()
  }
}

//MARK: - UICollectionViewDataSource
extension ChannelsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    cells = channelModel.getVisibleChannels().map({ (channel) -> CellData in
      CellData.channel(channel)
      
    })
    
    if cells.count > 1 {
      self.cells.insert(.allNewsChannel, at: 0)
    }
    return cells.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let channelCell = cells[indexPath.item]
    
    switch channelCell {
    case .allNewsChannel:
      let cell = collectionView.dequeueCell(AllNewsChannelCollectionViewCell.self, for: indexPath)
      
      let lastNews = channelModel.getLastNewsForAllNewsChannel()
      let unreadNewsCount = channelModel.getUnreadNewsCount()
      
      cell.configure(title: NSLocalizedString("news.titleCell.allNews", comment: ""), subtitle: lastNews?.title ?? "", urlImage: lastNews?.urlToImage, countOfUnreadNews: unreadNewsCount)
      
      return cell
      
    case .channel(let channel):
      let cell = collectionView.dequeueCell(ChannelCollectionViewCell.self, for: indexPath)

      let lastNews = (channel.news?.allObjects as? [NewsEntity])?.sorted(by: { (n1, n2) -> Bool in
      n1.date > n2.date
      }).first
      
      let unreadNewsCount = channelModel.getUnreadNewsCountFor(channel: channel)
      
      cell.configure(title: channel.title ?? "" , subtitle: lastNews?.title ?? "", urlImage: lastNews?.urlToImage, countOfUnreadNews: unreadNewsCount)
      
      return cell
    }
  }
}




