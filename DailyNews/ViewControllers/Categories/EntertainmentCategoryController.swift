//
//  FeedViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class EntertainmentCategoryController: FeaturedCategoryController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func fetchNews(page: Int) {
        let dispatchGroup = DispatchGroup()
        var headerGroup: [THArticle] = []
        var group: [THArticle] = []
        activityIndicatorView.startAnimating()

        dispatchGroup.enter()
        dispatchQueue.async {
            FetchNews.shared.fetchData(THRequest(country: "us", category: .entertainment, qWord: nil, pageSize: 10, page: page)) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let news):
                    if news.articles.count < 10 {
                        self.hasMoreNews = false
                    }
                    group.append(contentsOf: news.articles)
                case .failure(let err):
                    print(err.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        dispatchQueue.async {
            FetchNews.shared.fetchData(THRequest(country: "us", category: .entertainment, qWord: nil, pageSize: 10, page: 1)) { (result) in
                switch result {
                case .success(let news):
                    headerGroup = news.articles
                case .failure(let err):
                    print(err.localizedDescription)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            self.headerNews = headerGroup
            self.news.append(contentsOf: group)
            self.collectionView.reloadData()
        }
    }
}
