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
    var newsForCells: BehaviorSubject<[EverythingPresentation]> = .init(value: [])
    
    var loading: Observable<Bool>
    var moreLoading: Observable<Bool>
    var loadPageTrigger: PublishSubject<Void>
    var loadNextPageTrigger: PublishSubject<Void>
    let disposeBag = DisposeBag()
    private let error = PublishSubject<Swift.Error>()
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        
        let Loading = ActivityIndicator()
        loading = Loading.asObservable()
        let moreLoad = ActivityIndicator()
        moreLoading = moreLoad.asObservable()
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
                    let news = self.service.fetch(self.page).map({
                        items in items.articles
                    })
                    let mappedNews = news.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    return mappedNews
                    .trackActivity(Loading)
                }
        }

        let nextRequest = self.moreLoading
            .sample(loadNextPageTrigger)
            .flatMap { isLoading -> Observable<[EverythingPresentation]> in
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
                    .trackActivity(moreLoad)
                }
        }

        let request = Observable.of(loadRequest, nextRequest)
            .merge()
            .share(replay: 1)

        let response = request.flatMapLatest { news -> Observable<[EverythingPresentation]> in
            request
                .do(onError: { _error in
                    self.error.onNext(_error)
                }).catchError({ error -> Observable<[EverythingPresentation]> in
                    Observable.empty()
                })
            }
        .share(replay: 1)
        
        Observable
            .combineLatest(request, response , newsForCells.asObservable()) { request, response, news in
                return self.page == 2 ? response : news + response
        }
        .sample(response)
        .bind(to: newsForCells)
        .disposed(by: disposeBag)
    }
    func openSafariVC(_ news: EverythingPresentation){
        
    }
}
