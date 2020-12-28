//
//  NewsNetworkService.swift
//  UnitBeanNews
//
//  Created by ar_ko on 19.12.2020.
//

import Foundation

class NewsNetworkService {
    private init() {}
    
    static func getNews(page: Int = 1, completion: @escaping(FeedResponse?) -> ()) {
        
        let urlString: String = "http://newsapi.org/v2/top-headlines?country=ru&page=\(page)&apiKey=6bd6f472a2574bcbbc05189fa6a70338"
        guard let url = URL(string: urlString) else { return }
        
        NetworkService.shared.getData(type: FeedResponse.self, url: url) { (json) in
            if let json = json as? FeedResponse {
                completion(json)
            } else {
                completion(nil)
            }
        }
    }
}
