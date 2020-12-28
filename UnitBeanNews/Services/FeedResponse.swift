//
//  FeedResponse.swift
//  UnitBeanNews
//
//  Created by ar_ko on 19.12.2020.
//

import Foundation

struct FeedResponse: Decodable {
    var articles: [News]
}

class News: Decodable {
    let author: String
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case url
        case urlToImage
        case publishedAt
        case description
        case content
    }
    
    enum SourceCodingKeys: String, CodingKey {
        case id
        case name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(String.self, forKey: .url)
        self.urlToImage = try? container.decode(String.self, forKey: .urlToImage)
        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
        
        let sourceContainer = try container.nestedContainer(keyedBy: SourceCodingKeys.self, forKey: .source)
        self.author = try sourceContainer.decode(String.self, forKey: .name)
        
    }
}
