//
//  FeaturedViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/9/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

final class SectionsViewModel {
    
    
    var service: NewsServiceProtocol
    let news: BehaviorSubject<[TopHeadlinePresentation]>
    var page = 2
    var category = THCategories.general
    let loading: Observable<Bool>
    var loadPageTrigger: PublishSubject<Void>
    var loadNextPageTrigger: PublishSubject<Void>
    let disposeBag = DisposeBag()
    
    private let error = PublishSubject<Swift.Error>()
    
    init(_ service: NewsServiceProtocol, _ category: THCategories) {
        
        self.service = service
        self.category = category
        news = .init(value: [])
        let loadingIndicator = ActivityIndicator()
        loading = loadingIndicator.asObservable()
        loadPageTrigger = PublishSubject<Void>()
        loadNextPageTrigger = PublishSubject<Void>()
        
        let loadRequest = loading
            .sample(loadPageTrigger)
            .flatMap { loading -> Observable<[TopHeadlinePresentation]>
                in
                if loading {
                    return Observable.empty()
                } else {
                    self.page = 2
                    self.news.onNext([])
                    let news = self.service.fetchTHNews(self.page, self.category).map {
                        $0.articles
                    }
                    let mappedNews = news.map {
                        $0.map {
                            items in TopHeadlinePresentation.init(topHeadline: items)
                        }
                    }
                    return mappedNews
                        .trackActivity(loadingIndicator)
                }
        }
        
        let nextPageRequest = loading
            .sample(loadNextPageTrigger)
            .flatMap { nextLoading -> Observable<[TopHeadlinePresentation]> in
                if nextLoading {
                    return Observable.empty()
                } else {
                    self.page = self.page + 1
                    let news = self.service.fetchTHNews(self.page, .general).map {
                        $0.articles
                    }
                    let mappedNews = news.map {
                        $0.map {
                            items in TopHeadlinePresentation.init(topHeadline: items)
                        }
                    }
                    return mappedNews
                        .trackActivity(loadingIndicator)
                }
        }
        
        let request = Observable.of(loadRequest, nextPageRequest)
            .merge()
            .share(replay: 1)
        
        let response = request.flatMapLatest { news -> Observable<[TopHeadlinePresentation]> in
            request
                .do(onError: {
                    _error in self.error.onNext(_error)
                }).catchError({ error ->
                    Observable<[TopHeadlinePresentation]> in
                    Observable.empty()
                    
                })
            
            }
        .share(replay: 1)
        
        Observable
            .combineLatest(request, response, news.asObservable()) { request, response, news
                in
                return self.page == 2 ? response : news + response
        }
        .sample(response)
        .bind(to: news)
        .disposed(by: disposeBag)
    }
    
}
