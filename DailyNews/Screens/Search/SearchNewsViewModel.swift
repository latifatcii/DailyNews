//
//  SearchNewsViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/13/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

final class SearchNewsViewModel {
    
    var service: NewsServiceProtocol
    var searchText: PublishSubject<String>
    var loading: Observable<Bool>
    let searchedNews: BehaviorSubject<[EverythingPresentation]>
    var loadNextPageTrigger: PublishSubject<Void>
    var page = 1
    let loadingIndicator = ActivityIndicator()
    private let error = PublishSubject<Swift.Error>()

    
    
    let disposeBag = DisposeBag()
    
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
        
        loading = loadingIndicator.asObservable()
        
        loadNextPageTrigger = PublishSubject<Void>()
        searchedNews = .init(value: [])
        searchText = PublishSubject<String>()

        
        
        let request = searchText
            .flatMapLatest { [weak self]
            search -> Observable<[EverythingPresentation]> in
            guard let self = self else { fatalError() }
            
            if search.isEmpty {
                return .just([])
            } else {
                self.page = 1
                self.searchedNews.onNext([])
                let lowerCasedSearchText = search.lowercased()
                let text = lowerCasedSearchText.replacingOccurrences(of: " ", with: "-")
                let news = self.service.fetchDataForSearchController(text, self.page).map {
                    $0.articles
                }
                let mappedNews = news.map {
                    $0.map {
                        news in EverythingPresentation.init(everything: news)
                    }
                }
                return mappedNews
//                    .trackActivity(self.loadingIndicator)
            }
        }.share(replay: 1)
        
        request
            .flatMapLatest {
            news -> Observable<[EverythingPresentation]> in
            request
                .do(onError: { _error in
                    self.error.onNext(_error)
                }).catchError({ error -> Observable<[EverythingPresentation]> in
                    Observable.empty()
                })
        }
    .share(replay: 1)
    .debug()
    .bind(to: searchedNews)
    .disposed(by: disposeBag)
        
    }
    
    func configure() {

        

    }
    
}
