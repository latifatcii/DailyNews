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
    var page = 2
    let dispatchQueue = DispatchQueue(label: "com.latifatci.DailyNews", qos: .background, attributes: .concurrent)
    
    
    var newsForCells: BehaviorSubject<[EverythingPresentation]> = .init(value: [])
    var loading: BehaviorSubject<Bool>
    var moreLoading: BehaviorSubject<Bool>
    var loadPageTrigger: PublishSubject<Void>
    var loadNextPageTrigger: PublishSubject<Void>
    let disposeBag = DisposeBag()
    private let error = PublishSubject<Swift.Error>()
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        
        loading = .init(value: false)
        moreLoading = .init(value: false)
        loadPageTrigger = PublishSubject()
        loadNextPageTrigger = PublishSubject()
        
        self.service = service
        
        let loadRequest = self.loading
            .sample(self.loadPageTrigger)
            .flatMap { loading -> Observable<[EverythingPresentation]> in
                if loading {
                    return Observable.empty()
                } else {
                    self.page = 2
                    self.newsForCells.onNext([])
                    let presentation = self.service.fetch(self.page).map({
                        items in items.articles
                    })
                    let last = presentation.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    //TODO
//                    self.loading.onNext(false)
                    return last
                }
                
        }

        
        let nextRequest = self.moreLoading
            .sample(loadNextPageTrigger)
            .flatMap { isLoading -> Observable<[EverythingPresentation]> in
                if isLoading {
                    return Observable.empty()
                } else {
                    self.page = self.page + 1
                    let presentation = self.service.fetch(self.page).map({
                        items in items.articles
                    })
                    let last = presentation.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    return last
                }
        }

        let request = Observable.of(loadRequest, nextRequest)
            .merge()
            .share(replay: 1)

        let response = request.flatMap { news -> Observable<[EverythingPresentation]> in
            request
                .do(onError: { _error in
                    self.error.onNext(_error)
                }).catchError({ error -> Observable<[EverythingPresentation]> in
                    Observable.empty()
                })
        }.share(replay: 1)

        Observable
            .combineLatest(request, response , newsForCells.asObservable()) { request, response, news in
                return self.page == 1 ? response : news + response
        }
        .sample(response)
        .bind(to: newsForCells)
        .disposed(by: disposeBag)
        
        
        
    }
    
    
//    func fetchNews() {
//
//        dispatchQueue.async {
//            self.service.fetchNewsFromEverything(ERequest(qWord: nil, qInTitle: nil, domains: nil, excludeDomains: nil, fromDate: nil, toDate: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: 2, sources: Constants.sourcesIds)) { [weak self] (result) in
//                guard let self = self else { return }
//                switch result {
//                case .success(let news):
//                    let cellNews = news.articles.map({EverythingPresentation.init(everything: $0)})
//                    self.newsForCells.onNext(cellNews)
//                case .failure(let err):
//                    print(err)
//                }
////                self.loading.onNext(false)
//            }
//        }
//    }
    
}
