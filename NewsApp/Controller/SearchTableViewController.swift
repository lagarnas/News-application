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
  private var resultLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  //MARK: - Variables
  private var channelModel: ChannelModel!
  private var filteredNews: [News] = []
  private var searchActivityIndicator: UIActivityIndicatorView!
  
  private let searchController = UISearchController(searchResultsController: nil)
  private var searchThrottleTimer: Timer?
  
  private var searchBarIsEmpty: Bool {
    guard let text = searchController.searchBar.text else { return false }
    return text.isEmpty
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initialization()
    setupSearchController()
    setupResultLabel()
    setupSearchActivityIndicator()
  }

  
  override func viewWillLayoutSubviews() {
    resultLabel.isHidden = self.filteredNews.isEmpty ? false : true
  }
  
  // MARK: - Private functions
  private func initialization() {
    tableView.register(UINib(nibName: NewsTableViewCell.nibName, bundle: nil), forCellReuseIdentifier:  NewsTableViewCell.reuseIdentifier)
    channelModel = ChannelModel()
  }
  
  private func setupResultLabel() {
    resultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    resultLabel.numberOfLines = 1
    resultLabel.lineBreakMode = .byWordWrapping
    
    resultLabel.text = NSLocalizedString("result", comment: "result of label")//"No results"
    resultLabel.adjustsFontSizeToFitWidth = true
    resultLabel.font = UIFont.boldSystemFont(ofSize: 18)
    resultLabel.textColor = .black
    resultLabel.sizeToFit()
    self.view.addSubview(resultLabel)
    resultLabel.translatesAutoresizingMaskIntoConstraints = false
    resultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    resultLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
  }
  
  private func setupSearchActivityIndicator() {
    searchActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    searchActivityIndicator.isHidden = true
    self.view.addSubview(searchActivityIndicator)
    searchActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
    searchActivityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    searchActivityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
    
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = NSLocalizedString("placeholderOfSearch", comment: "placeholder")//"Search news"
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
      self.filteredNews = []
      self.tableView.reloadData()
      searchActivityIndicator.isHidden = true
      searchThrottleTimer?.invalidate()
      
    } else {
      resultLabel.isHidden = true
      searchActivityIndicator.isHidden = false
      searchActivityIndicator.startAnimating()
      searchThrottleTimer?.invalidate()
      searchThrottleTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) {_ in
        
        self.channelModel.loadFilteredNews(filter: searchController.searchBar.text!, completion: {
          self.filteredNews = $0
          self.tableView.reloadData()
          self.searchActivityIndicator.stopAnimating()
        }) { [weak self] (error) in
            ToastService.showToast(view: (self?.view)!, message: error.localizedDescription)
            self?.searchActivityIndicator.stopAnimating()
        }
      }
      if !self.filteredNews.isEmpty {
        self.searchActivityIndicator.stopAnimating()
        self.searchActivityIndicator.hidesWhenStopped = true
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
    cell.configure(author: newsItem.author, date: newsItem.date.timeAgo(), title: newsItem.title, subtitle: newsItem.subtitle ?? "" , urlImage: newsItem.urlToImage)
    
    return cell
  }
  
  // MARK: - Table view delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let filteredNews = self.filteredNews[indexPath.row]
    let url = filteredNews.url
    showWebSite(url: url!)
  }
}
