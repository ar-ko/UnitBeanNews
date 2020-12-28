//
//  NewsPresenter.swift
//  UnitBeanNews
//
//  Created by ar_ko on 21.12.2020.
//

import UIKit

protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    weak var viewController: NewsfeedDisplayLogic?
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "d MMMM 'в' HH:mm"
        return df
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        
        switch response {
        case .presentNewsfeed(feed: let feed):
            let cells = feed.articles.map { (feedItem) in
                cellViewModel(from: feedItem)
            }
            
            let feedViewModel = FeedViewModel.init(cells: cells)
            
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        }
    }
    
    private func cellViewModel(from news: News) -> FeedViewModel.Cell {
        // Setup comments
        let comments = String(Int.random(in: 0...200))
        
        // Setup title and author
        var title = news.title.uppercased()
        var author = news.author
        
        if let index = title.lastIndex(of: "-"){
            author = String(title[index...])
            author = String(author.dropFirst(2))
            author = author.lowercased()
            author = author.prefix(1).uppercased() + author.dropFirst(1)
            title = String(title[..<index])
        }
        
        // Setup publishDate
        var publishDate = news.publishedAt
        if let date = getDate(date: news.publishedAt) {
            publishDate = dateFormatter.string(from: date)
        }
        
        return FeedViewModel.Cell(title: title,
                                  author: author,
                                  publishDate: publishDate,
                                  numberOfComments: comments,
                                  urlToImage: news.urlToImage,
                                  url: news.url)
        
        
    }
    
    private func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
    
}
