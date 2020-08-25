//
//  ChannelNewsViewController.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 17.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

final class NewsViewController: UIViewController {
  //MARK: - @IBOutlets
  @IBOutlet private weak var newsTableView: UITableView!
  
  @IBOutlet private weak var markAsReadButtonClicked: UIBarButtonItem!
  //MARK: - Variables
  private var channelModel: ChannelModel!
  private var mode: Mode!
  
  private var fetchedResultsController: NSFetchedResultsController<NewsEntity>!
  
  private let refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    return refreshControl
  }()
  
  enum Mode {
    case channel(ChannelEntity)
    case channelOfAllNews
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initialization()
    markAsReadButtonClicked.title = NSLocalizedString("markAsReadButton", comment: "")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refreshControl.beginRefreshing()
    refresh(sender: refreshControl)
  }
  
  @IBAction func markAsReadButton(_ sender: UIBarButtonItem) {
    switch self.mode {
    case .channelOfAllNews:
      channelModel.readAllNews()
    case .channel(let channel):
      channelModel.readAllNews(in: channel)
    case .none:
      break
    }
  }
  
  // MARK: - Public functions
  func set(mode: Mode, channelModel: ChannelModel, title: String) {
    self.mode = mode
    self.channelModel = channelModel
    self.title = title
  }
  
  private func initialization() {
    newsTableView.refreshControl = refreshControl
    newsTableView.register(UINib(nibName: NewsTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
    
    fetchData()
    fetchedResultsController.delegate = self
  }
  
  private func fetchData() {
    switch self.mode {
    case .channelOfAllNews:
      fetchedResultsController = PersistenceService.shared.setupNewsFetchedResultController()
    case .channel(let channel):
      fetchedResultsController = PersistenceService.shared.setupNewsFetchedResultController(channel: channel)
    case .none:
      break
    }
    try! fetchedResultsController.performFetch()
  }
  
  // MARK: - Private functions
  @objc private func refresh(sender: UIRefreshControl) {
    
    switch self.mode {
    case .channelOfAllNews:
      self.refreshControl.endRefreshing()
      
    case .channel(let channel):
      self.channelModel.updateAllNewsFor(channel: channel) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(_): break
        case .failure(let error):
          ToastService.showToast(view: self.view, message: error.localizedDescription)
        }
        self.refreshControl.endRefreshing()
      }
    case .none:
      break
    }
  }
  
  private func showWebSite(url: URL) {
    let webVC = SFSafariViewController(url: url)
    present(webVC, animated: true)
  }
}

// MARK: Extensions
extension NewsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let sections = fetchedResultsController.sections else { return 0 }
    return sections[section].numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueCell(NewsTableViewCell.self, for: indexPath)
    
    let newsItem = fetchedResultsController.object(at: indexPath)
    
    cell.configure(author: newsItem.author,
                   date: newsItem.date.timeAgo(),
                   title: newsItem.title ?? "",
                   subtitle: newsItem.subtitle == "" ? newsItem.content: newsItem.subtitle,
                   urlImage: newsItem.urlToImage,
                   isRead: newsItem.isRead)

    return cell
  }
}

extension NewsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let news = fetchedResultsController.object(at: indexPath)
    //говорим модели что эта новость прочитана
    channelModel.readNews(news)
    let url = news.url
    showWebSite(url: url!)
  }
}

extension NewsViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    newsTableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    newsTableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      newsTableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .update:
      newsTableView.reloadRows(at: [indexPath!], with: .automatic)
      self.refreshControl.endRefreshing()
    case .move:
      newsTableView.deleteRows(at: [indexPath!], with: .automatic)
      newsTableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      newsTableView.deleteRows(at: [indexPath!], with: .automatic)
    @unknown default:
      fatalError()
    }
  }
}

