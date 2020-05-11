//
//  CategoriesHeaderViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/11/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

final class SectionsHeaderViewModel {
    
    var service: NewsServiceProtocol
    var sectionHeaderNews: BehaviorSubject<[TopHeadlinePresentation]>
    let disposeBag = DisposeBag()
    let page = 1
//    var category: THCategories
    
    var loading: Observable<Bool>
    var loadingTrigger: PublishSubject<Void>
    
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
//        self.category = category
        
        sectionHeaderNews = .init(value: [])
        let loadingIndicator = ActivityIndicator()
        loading = loadingIndicator.asObservable()
        loadingTrigger = PublishSubject<Void>()
        
        let loadRequest = loading
        .sample(loadingTrigger)
            .flatMap { [weak self]
                 isLoading -> Observable<[TopHeadlinePresentation]> in
                guard let self = self else { fatalError() }
                if isLoading {
                    return Observable.empty()
                } else {
                    self.sectionHeaderNews.onNext([])
                    let news = self.service.fetchTHNews(self.page, .general).map {
                        $0.articles
                    }
                    let mappedNews = news.map {
                        news in news.map {
                            TopHeadlinePresentation.init(topHeadline: $0)
                        }
                    }
                    return mappedNews
                    .trackActivity(loadingIndicator)
                }
        }
        loadRequest
        .bind(to: sectionHeaderNews)
        .disposed(by: disposeBag)
        
    }
}
