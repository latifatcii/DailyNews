//
//  NewsViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 4/27/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

final class NewsViewModel {
    var service: NewsServiceProtocol
    var newsForCells: BehaviorSubject<[EverythingPresentation]> = .init(value: [])
    let loading: BehaviorSubject<Bool> = .init(value: true)
    let dispatchQueue = DispatchQueue(label: "com.latifatci.DailyNews", qos: .background, attributes: .concurrent)
    let loadPageTrigger: PublishSubject<Void> = PublishSubject()
    let loadNextPageTrigger: PublishSubject<Void> = PublishSubject()
    let request = ERequest(qWord: nil, qInTitle: nil, domains: nil, excludeDomains: nil, fromDate: nil, toDate: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: 2, sources: Constants.sourcesIds)
    var page = 2
    let disposeBag = DisposeBag()
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
//        fetchNews()

        let loadRequest = self.loading.asObservable()
            .sample(self.loadPageTrigger)
            .flatMap { loading -> Observable<[EverythingPresentation]> in
                if !loading {
                    return Observable.empty()
                } else {
                    self.page = 2
                    self.newsForCells.onNext([])
                    let presentation = self.service.fetch(self.request).map({
                        items in items.articles
                    })
                    let last = presentation.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    //TODO
                    self.loading.onNext(false)
                    return last
                    }
                }
        
        loadRequest.bind(to: self.newsForCells)
        .disposed(by: disposeBag)
            
        }
        
    
    func fetchNews() {
        dispatchQueue.async {
            self.service.fetchNewsFromEverything(ERequest(qWord: nil, qInTitle: nil, domains: nil, excludeDomains: nil, fromDate: nil, toDate: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: 2, sources: Constants.sourcesIds)) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let news):
                    let cellNews = news.articles.map({EverythingPresentation.init(everything: $0)})
                    self.newsForCells.onNext(cellNews)
                case .failure(let err):
                    print(err)
                }
                self.loading.onNext(false)
            }
        }
    }
    
}
