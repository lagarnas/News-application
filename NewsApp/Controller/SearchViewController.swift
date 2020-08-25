//
//  SearchTableViewController.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 22.06.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import UIKit
import SafariServices
import Toast_Swift

final class SearchViewController: UIViewController {
  //MARK: - @IBOutlets
  @IBOutlet private weak var resultLabel: UILabel!
  @IBOutlet private weak var searchActivityIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var tableView: UITableView!
  
  //MARK: - Variables
  private var channelModel: ChannelModel!
  private var filteredNews: [News] = []
  
  private var searchController = UISearchController(searchResultsController: nil)
  private var searchThrottleTimer: Timer?
  
  private var searchBarIsEmpty: Bool {
    guard let text = searchController.searchBar.text else { return false }
    return text.isEmpty
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.title = NSLocalizedString("search.title", comment: "")
    self.navigationController?.tabBarItem.title = NSLocalizedString("search.tabBarItem", comment: "")
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initialization()
  }
  
  // MARK: - Private functions
  private func initialization() {
    tableView.register(UINib(nibName: NewsTableViewCell.nibName, bundle: nil), forCellReuseIdentifier:  NewsTableViewCell.reuseIdentifier)
    
    setupSearchController()
    resultLabel.text = NSLocalizedString("search.placeholder.noresult", comment: "")
    searchActivityIndicator.stopAnimating()
    searchActivityIndicator.hidesWhenStopped = true
  }
  
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = NSLocalizedString("search.placeholder.searchNews", comment: "")
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
  
  private func showWebSite(url: URL) {
    let webVC = SFSafariViewController(url: url)
    present(webVC, animated: true)
  }
}

extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    if searchBarIsEmpty {
      filteredNews = []
      tableView.reloadData()
      searchActivityIndicator.isHidden = true
      searchThrottleTimer?.invalidate()
      resultLabel.isHidden = false
      
    } else {
      resultLabel.isHidden = true
      searchActivityIndicator.isHidden = false
      searchActivityIndicator.startAnimating()
      searchThrottleTimer?.invalidate()
      searchThrottleTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) {_ in
        ChannelNetworkModel.shared.loadFilteredNews(filter: searchController.searchBar.text!) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let news):
            self.filteredNews = news
            self.resultLabel.isHidden = !self.filteredNews.isEmpty
            self.tableView.reloadData()
            self.searchActivityIndicator.stopAnimating()
          case .failure(let error):
            ToastService.showToast(view: self.view, message: error.localizedDescription)
            self.searchActivityIndicator.stopAnimating()
          }
        }
      }
    }
  }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: - Table view data source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredNews.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(NewsTableViewCell.self, for: indexPath)
    let newsItem = filteredNews[indexPath.row]
    cell.configure(author: newsItem.author, date: newsItem.date.timeAgo(), title: newsItem.title, subtitle: newsItem.subtitle ?? "" , urlImage: newsItem.urlToImage, isRead: newsItem.isRead)
    
    return cell
  }
  
  // MARK: - Table view delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let filteredNews = self.filteredNews[indexPath.row]
    let url = filteredNews.url
    showWebSite(url: url!)
  }
}
