//
//  SourceModel.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 17.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

protocol NewsModelDelegate: class {
    func didUpdateNews(_ model: NewsModel)
}

final class NewsModel {
    
    struct Const {
        static let key = "com.lagarnas.NewsApp.selectedNews"
    }
    
    private let userDefaults = UserDefaults.standard
    private var sources: [Source] = []
    
    //MARK: Delegates
    weak var delegate: NewsModelDelegate?

    
    //MARK: - loadChannels()
    func loadChannels() {
        NetworkManager.shared.getChannels { channels in
            self.sources = channels.getSources()
            self.updateLocalData()
        }
    }
    
    //MARK: - loadArticles()
    func loadArticles(channel: Source, completion: @escaping ([Article])-> Void) {
        NetworkManager.shared.getArticles(channel: channel, completion: completion)
    }
    
    //MARK: - updateLocalData()
    private func updateLocalData() {
        let visible = getVisibleSet()
        visible.forEach { (id) in
            for (index, source) in sources.enumerated() {
                    sources[index].isVisible = visible.contains(source.channel.id)
            }
        }
        
        let newVisible = sources.compactMap { $0.isVisible ? $0.channel.id : $0.channel.name!}
        
        userDefaults.set(Array(newVisible), forKey: Const.key)
        self.delegate?.didUpdateNews(self)
    }
    
    //MARK: - getSelectedSet()
    private func getVisibleSet() -> Set<String> {
        let selectedArray = userDefaults.array(forKey: Const.key) as? [String] ?? [String]()
        return Set(selectedArray)
    }
    
    //MARK: - updateChannel()
    private func updateSource(id: String, isVisible: Bool) {
        if let idx = sources.firstIndex(where: { $0.channel.id == id }) {
            sources[idx].isVisible = isVisible
        }
        
        delegate?.didUpdateNews(self)
    }
    
    //MARK: - setVisible()
    func setVisible(id: String, isVisible: Bool) {
        var selectedSet = getVisibleSet()

        if isVisible {
            selectedSet.insert(id)
        } else {
            selectedSet.remove(id)
        }
        userDefaults.set(Array(selectedSet), forKey: Const.key)
        updateSource(id: id, isVisible: isVisible)
    }
    
    //MARK: - getVisibleSources()
    func getVisibleSources() -> [Source] {
        sources.filter{ $0.isVisible }
    }
    
    //MARK: - getAllSources()
    func getAllSources() -> [Source] {
        sources
    }
    
    
}
