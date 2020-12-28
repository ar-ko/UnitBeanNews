//
//  NewsInteractor.swift
//  UnitBeanNews
//
//  Created by ar_ko on 21.12.2020.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    var feedResponces: FeedResponse?
    var page = 1
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
        
        case .getNewsfeed:
            NewsNetworkService.getNews { [weak self] (feedResponce) in
                guard let feedResponce = feedResponce else { return }
                self?.feedResponces = feedResponce
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feedResponce))
            }
            page = 1
        case .newsfeedNextPage:
            page += 1
            NewsNetworkService.getNews(page: page) { [weak self] (feedResponce)in
                guard let feedResponce = feedResponce else { return }
                self?.feedResponces?.articles += feedResponce.articles
                
                self?.presenter?.presentData(response: .presentNewsfeed(feed: self!.feedResponces!))
            }
            
        }
        
    }
    
}
