//
//  NewsHeaderViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

final class NewsHeaderViewModel {
    var service: NewsServiceProtocol
    var newsForHeader: BehaviorSubject<[EverythingPresentation]> = .init(value: [])
    let loading: BehaviorSubject<Bool> = .init(value: true)
    let refreshing: BehaviorSubject<Bool> = .init(value: false)
    let dispatchQueue = DispatchQueue(label: "com.latifatci.DailyNews", qos: .background, attributes: .concurrent)

    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
        fetchHeaderNews()
    }
    
    func fetchHeaderNews() {
        dispatchQueue.async {
            self.service.fetchNewsFromEverything(ERequest(qWord: nil, qInTitle: nil, domains: nil, excludeDomains: nil, fromDate: nil, toDate: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: 1, sources: Constants.sourcesIds)) { (result) in
                switch result {
                case .success(let news):
                    let headerNews = news.articles.map({EverythingPresentation.init(everything: $0)})
                    self.newsForHeader.onNext(headerNews)
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
