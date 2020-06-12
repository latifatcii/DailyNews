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
    let news: BehaviorSubject<[EverythingPresentation]> = .init(value: [])
    
    let loading: Observable<Bool>
    var loadPageTrigger: PublishSubject<Void>
    var loadNextPageTrigger: PublishSubject<Void>
    let disposeBag = DisposeBag()
    var loadingIndicator: ActivityIndicator!
        
    private let error = PublishSubject<Swift.Error>()
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        loadingIndicator = ActivityIndicator()
        loading = loadingIndicator.asObservable()
        loadPageTrigger = PublishSubject()
        loadNextPageTrigger = PublishSubject()
        self.service = service
        load()
    }

    func load() {

        dataObserver.subscribe(onNext: {
            print("refresh data NewsViewModel")
            }).disposed(by: disposeBag)
        
        let loadRequest = self.loading
            .sample(self.loadPageTrigger)
            .flatMap { [weak self] loading -> Observable<[EverythingPresentation]> in
                guard let self = self else { fatalError() }
                if loading {
                    return Observable.empty()
                } else {
                    self.page = 2
                    self.news.onNext([])
                    let news = self.service.fetch(self.page).map({
                        items in items.articles
                    })
                    let mappedNews = news.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    return mappedNews
                        .trackActivity(self.loadingIndicator)
                }
        }

        let nextRequest = self.loading
            .sample(loadNextPageTrigger)
            .flatMap { [weak self] isLoading -> Observable<[EverythingPresentation]> in
                guard let self = self else { fatalError() }
                if isLoading {
                    return Observable.empty()
                } else {
                    self.page = self.page + 1
                    let news = self.service.fetch(self.page).map({
                        items in items.articles
                    })
                    let mappedNews = news.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    return mappedNews
                        .trackActivity(self.loadingIndicator)
                }
        }
        let request = Observable.of(loadRequest, nextRequest)
            .merge()
            .share(replay: 1)

        let response = request
            .flatMapLatest { news -> Observable<[EverythingPresentation]> in
            request
                .do(onError: { _error in
                    self.error.onNext(_error)
                }).catchError({ error ->
                    Observable<[EverythingPresentation]> in
                    Observable.empty()
                    
                })
            }
        .share(replay: 1)
        
        Observable
            .combineLatest(request, response , news.asObservable()) { request, response, news in
                return self.page == 2 ? response : news + response
        }
        .sample(response)
        .bind(to: news)
        .disposed(by: disposeBag)
    }
    
    
}
