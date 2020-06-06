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
    let news: BehaviorSubject<[EverythingPresentation]> = .init(value: [])
    var page = 1
    let loading: Observable<Bool>
    let loadPageTrigger: PublishSubject<Void>
    let disposeBag = DisposeBag()


    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
        let Loading = ActivityIndicator()
        loading = Loading.asObservable()
        loadPageTrigger = PublishSubject<Void>()
        
        dataObserver.subscribe(onNext: {
            print("refresh data NewsHeaderViewModel")
            }).disposed(by: disposeBag)
        
        let loadRequest = self.loading
            .sample(self.loadPageTrigger)
            .flatMap { [weak self]
                loading -> Observable<[EverythingPresentation]> in
                guard let self = self else { fatalError() }
                if loading {
                    return Observable.empty()
                } else {
                    self.news.onNext([])
                    let news = self.service.fetch(self.page).map({
                        items in items.articles
                    })
                    let headerNews = news.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    return headerNews
                    .trackActivity(Loading)
                }
            }
        
        loadRequest
            .bind(to: news)
            .disposed(by: disposeBag)
    }
}
