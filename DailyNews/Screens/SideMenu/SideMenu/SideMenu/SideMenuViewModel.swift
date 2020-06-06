//
//  SideMenuViewModel.swift
//  DailyNews
//
//  Created by Latif Atci on 5/15/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SideMenuViewModel {
    
    let service: NewsServiceProtocol
    let disposeBag = DisposeBag()
    let sources: BehaviorRelay<[ExpandedSources]>
    let loading: Observable<Bool>
    let loadingTrigger: PublishSubject<Void>
    
    init(_ service: NewsServiceProtocol = NewsService()) {
        self.service = service
        
        let loadingIndicator = ActivityIndicator()
        loading = loadingIndicator.asObservable()
        sources = BehaviorRelay<[ExpandedSources]>.init(value: [])
        loadingTrigger = PublishSubject<Void>()
        
        let generalSource = fetchAndMapSources(.general)
        let businessSource = fetchAndMapSources(.business)
        let sportsSource = fetchAndMapSources(.sports)
        let technologySource = fetchAndMapSources(.technology)
        let scienceSource = fetchAndMapSources(.science)
        let entertainmentSource = fetchAndMapSources(.entertainment)
        let healthSource = fetchAndMapSources(.health)
        
        Observable.zip(generalSource, businessSource, sportsSource, technologySource, scienceSource, entertainmentSource, healthSource)
            .subscribe(onNext: {
                (general, business, sports, technology, science, entertainment, health) in
                self.sources.accept([general, business, sports, technology, science, entertainment, health])
            })
        .disposed(by: disposeBag)

    }
    private func fetchAndMapSources(_ category: SourceCategories) -> Observable<ExpandedSources> {
        let source = service.fetchSources(SRequest(category: category, language: "en", country: nil)).map {
            $0.sources
        }
        return source.map {
            ExpandedSources.init(category: category, sources: $0)
        }
    }
}

