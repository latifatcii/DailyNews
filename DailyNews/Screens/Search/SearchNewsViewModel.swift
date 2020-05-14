//
//  SearchNewsViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/13/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchNewsViewModel {
    
    var service: NewsServiceProtocol
    let searchText: BehaviorRelay<String>
    
    let loading: Observable<Bool>
    let searchedNews: BehaviorSubject<[EverythingPresentation]>
    var loadNextPageTrigger: PublishSubject<Void>
    var page = 1
    private let error = PublishSubject<Swift.Error>()
    let cancelButtonClicked: PublishSubject<Void>
    let loadingIndicator = ActivityIndicator()
    let disposeBag = DisposeBag()
    
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
        
        loading = loadingIndicator.asObservable()
        cancelButtonClicked = PublishSubject<Void>()
        loadNextPageTrigger = PublishSubject<Void>()
        searchedNews = .init(value: [])
        searchText = .init(value: "")
        
        
        let request = searchText
            .flatMap { [weak self]
                text -> Observable<[EverythingPresentation]> in
                guard let self = self else { fatalError() }
                if text.isEmpty {
                    return .just([])
                } else {
                    self.page = 1
                    self.searchedNews.onNext([])
                    
                    let news = self.service.fetchDataForSearchController(self.queryString(), self.page).map {
                        $0.articles
                    }
                    let mappedNews = news.map {
                        $0.map {
                            news in EverythingPresentation.init(everything: news)
                        }
                    }
                    return mappedNews
                        .trackActivity(self.loadingIndicator)
                }
        }.share(replay: 1)
        
        let nextRequest = loading
            .sample(loadNextPageTrigger)
            .flatMap { [weak self]
                isLoading -> Observable<[EverythingPresentation]> in
                guard let self = self else { fatalError() }
                if isLoading {
                    return .just([])
                } else {
                    self.page = self.page + 1
                    let news = self.service.fetchDataForSearchController(self.queryString(), self.page).map {
                        $0.articles
                    }
                    let mappedNews = news.map {
                        $0.map {
                            news in EverythingPresentation.init(everything: news)
                        }
                    }
                    return mappedNews
                        .trackActivity(self.loadingIndicator)
                }
        }
        
        
        let finalRequest = Observable.of(request, nextRequest)
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
        .share(replay: 1)
        
        Observable
            .combineLatest(request, response , searchedNews.asObservable()) { request, response, news in
                return self.page == 1 ? response : news + response
        }
        .sample(response)
        .bind(to: searchedNews)
        .disposed(by: disposeBag)
        
        cancelButtonClicked.subscribe(onNext: {
            self.searchedNews.onNext([])
            })
        .disposed(by: disposeBag)
        
    }
    func queryString() -> String {
        let lowerCasedQuery = searchText.value.lowercased()
        let query = lowerCasedQuery.replacingOccurrences(of: " ", with: "-")
        return query
    }
}
