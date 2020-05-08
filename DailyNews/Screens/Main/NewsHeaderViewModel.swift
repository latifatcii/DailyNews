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
    var page = 1
    let loading: Observable<Bool>
    let loadPageTrigger: PublishSubject<Void>
    let disposeBag = DisposeBag()


    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
        let Loading = ActivityIndicator()
        loading = Loading.asObservable()
        loadPageTrigger = PublishSubject<Void>()
        
        let loadRequest = self.loading
            .sample(self.loadPageTrigger)
            .flatMap{
                loading -> Observable<[EverythingPresentation]> in
                if loading {
                    return Observable.empty()
                } else {
                    self.newsForHeader.onNext([])
                    let presentation = self.service.fetch(self.page).map({
                        items in items.articles
                    })
                    let last = presentation.map({
                        items in items.map({
                            item in EverythingPresentation.init(everything: item)
                        })
                    })
                    return last
                    .trackActivity(Loading)
                }
            }
        
        loadRequest
            .bind(to: newsForHeader)
            .disposed(by: disposeBag)
    }
}
