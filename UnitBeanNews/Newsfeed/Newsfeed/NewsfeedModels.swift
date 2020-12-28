//
//  NewsModels.swift
//  UnitBeanNews
//
//  Created by ar_ko on 21.12.2020.
//

import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsfeed
        case newsfeedNextPage
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsfeed(feed: FeedResponse)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsfeed(feedViewModel: FeedViewModel)
      }
    }
  }
  
}


struct FeedViewModel {
    let cells: [Cell]
    
    struct Cell: FeedCellViewModel {
        var title: String
        var author: String
        var publishDate: String
        var numberOfComments: String
        var urlToImage: String?
        var url: String
    }
}
