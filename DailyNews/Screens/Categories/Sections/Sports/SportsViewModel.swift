//
//  SportsViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/9/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

final class SportsViewModel: SectionsViewModelType {
    
     var service: NewsService
     let news: BehaviorSubject<[TopHeadlinePresentation]>
     var page = 2
     var category = THCategories.sports
     var loading: Observable<Bool>
     var nextPageLoading: Observable<Bool>
     var loadTrigger: PublishSubject<Void>
     var nextPageLoadTrigger: PublishSubject<Void>
     let disposeBag = DisposeBag()
     private let error = PublishSubject<Swift.Error>()
     
     init(_ service: NewsService = NewsService()) {
         self.service = service
         
         news = .init(value: [])
         let loadingIndicator = ActivityIndicator()
         loading = loadingIndicator.asObservable()
         let moreLoading = ActivityIndicator()
         nextPageLoading = moreLoading.asObservable()
         loadTrigger = PublishSubject<Void>()
         nextPageLoadTrigger = PublishSubject<Void>()
         
         let loadRequest = loading
             .sample(loadTrigger)
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
         
         let nextPageRequest = nextPageLoading
             .sample(nextPageLoadTrigger)
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
                         .trackActivity(moreLoading)
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
