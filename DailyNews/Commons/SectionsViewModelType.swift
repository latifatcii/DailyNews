//
//  CategoriesViewModelType.swift
//  DailyNews
//
//  Created by Latif Atci on 5/9/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

protocol SectionsViewModelType {
    var service: NewsService { get }
    var category: THCategories { get }
    var loading: Observable<Bool> { get }
    var nextPageLoading: Observable<Bool> { get }
    var loadTrigger: PublishSubject<Void> { get }
    var nextPageLoadTrigger: PublishSubject<Void> { get }
    var news: BehaviorSubject<[TopHeadlinePresentation]> { get }
}
