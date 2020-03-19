//
//  FeedViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class BusinessSectionController :  FeaturedSectionController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func fetchNews(page: Int) {
        let dispatchGroup = DispatchGroup()
        var headerGroup : [THArticle] = []
        var group : [THArticle] = []
        activityIndicatorView.startAnimating()
        dispatchGroup.enter()
        FetchTopHeadline.shared.fetchData(THRequest(country: "us", category: .business, q: nil, pageSize: 10, page: page)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                if news.articles.count < 10 {
                    self.hasMoreNews = false
                }
                group.append(contentsOf: news.articles)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        FetchTopHeadline.shared.fetchData(THRequest(country: "us", category: .business, q: nil, pageSize: 5, page: 1)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                headerGroup.append(contentsOf: news.articles)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            self.headerNews.append(contentsOf: headerGroup)
            self.news.append(contentsOf: group)
            self.collectionView.reloadData()

        }
    }

}
