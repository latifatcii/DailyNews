//
//  SideMenuNewsViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/15/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SideMenuNewsViewModel {
    
    let service: NewsServiceProtocol
    //    let sourceName: Observable<String>
    //    let sourceId: Observable<String>
    let news: BehaviorSubject<[EverythingPresentation]> = .init(value: [])
    var page = 1
    let loading: Observable<Bool>
    let loadPageTrigger: PublishSubject<Void>
    let loadNextPageTrigger: PublishSubject<Void>
    let disposeBag = DisposeBag()
    private let error = PublishSubject<Swift.Error>()
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
        
        let loadingIndicator = ActivityIndicator()
        loading = loadingIndicator.asObservable()
        loadPageTrigger = PublishSubject<Void>()
        loadNextPageTrigger = PublishSubject<Void>()
        
        let request = loading
            .sample(loadPageTrigger)
            .flatMap { [weak self] loading -> Observable<[EverythingPresentation]> in
                guard let self = self else { fatalError() }
                if loading {
                    return Observable.empty()
                } else {
                    self.page = 1
                    self.news.onNext([])
                    let news = self.service.fetchDataForSearchController("cnn", self.page).map {
                        $0.articles
                    }
                    let mappedNews = news.map {
                        news in news.map {
                            EverythingPresentation.init(everything: $0)
                        }
                    }
                    return mappedNews
                        .trackActivity(loadingIndicator)
                }
        }
        let nextRequest = self.loading
            .sample(loadNextPageTrigger)
            .flatMap { [weak self] loading -> Observable<[EverythingPresentation]> in
                guard let self = self else { fatalError() }
                if loading {
                    return Observable.empty()
                } else {
                    self.page = self.page + 1
                    let news = self.service.fetchDataForSearchController("cnn", self.page).map {
                        $0.articles
                    }
                    let mappedNews = news.map {
                        news in news.map {
                            EverythingPresentation.init(everything: $0)
                        }
                    }
                    return mappedNews
                        .trackActivity(loadingIndicator)
                }
        }
        
        let finalRequest = Observable.of(request,nextRequest)
            .merge()
            .share(replay: 1)
        
        let response = finalRequest
            .flatMapLatest { news -> Observable<[EverythingPresentation]> in
                finalRequest
                    .do(onError: { _error in
                        self.error.onNext(_error)
                    }).catchError({ error -> Observable<[EverythingPresentation]> in
                        Observable.empty()
                    })
                
        }
    .debug()
    .share(replay: 1)
        
        Observable
            .combineLatest(finalRequest, response , news.asObservable()) { request, response, news in
                return self.page == 1 ? response : news + response
        }
        .sample(response)
        .bind(to: news)
        .disposed(by: disposeBag)
        
    }
}
