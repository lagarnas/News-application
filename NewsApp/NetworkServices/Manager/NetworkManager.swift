//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Анастасия Лагарникова on 16.03.2020.
//  Copyright © 2020 lagarnas. All rights reserved.
//

import Foundation

class NetworkManager {
    private struct Const{
        static let apiKey = "8d903c76d5624851ba917e6c2fcec07e"
     }
    
    static let shared = NetworkManager()
    
    private var session: URLSession {
        URLSession.shared
    }
    private init() { }
    
    private func setURLComponents(path: String, queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "newsapi.org"
            urlComponents.path = path
            urlComponents.queryItems = queryItems + [URLQueryItem(name: "apiKey", value: Const.apiKey)]
        
        return urlComponents.url!
    }
    
    //MARK: - getChannels()
    func getChannels(completion: @escaping ([Source])-> Void) {
        
        let request = URLRequest(url: setURLComponents(path: "/v2/sources", queryItems: []))
        
        let task = session.dataTask(with: request) { (data, _, error) in
            
            guard let data = data else { return }
                do {
                    let sources = try JSONDecoder().decode(Sources.self, from: data)
                    
                    completion(sources.sources)
                } catch { print(error) }
        }
        task.resume()
    }
    
    //MARK: - getArticles()
    func getArticles(channel: Source, completion: @escaping ([Article]) -> Void) {
        
        let request = URLRequest(url: setURLComponents(path: "/v2/top-headlines", queryItems: [URLQueryItem(name: "sources", value: channel.id)]))
        
        let task = session.dataTask(with: request) { (data, _, error) in

            guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let news = try decoder.decode(News.self, from: data)

                    completion(news.articles)
                } catch { print(error) }
        }
        task.resume()
    }
}

