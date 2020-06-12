//
//  MockNewsService.swift
//  DailyNewsUnitTests
//
//  Created by Latif Atci on 6/11/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxSwift

@testable import DailyNews

class MockNewsService: NewsServiceProtocol {
    
    var eNews: ENewsModel?
    var thNews: THNewsModel?
    var sources: SourcesModel?
    let urlReq: URLRequest = URLRequest(url: URL(string: "fakeURL")!)
    
    func fetchDataForSearchController(_ searchedQuery: String, _ page: Int) -> Observable<ENewsModel> {
        return apiRequestEverything(urlReq)
    }
    
    func fetchSources(_ from: SRequest) -> Observable<SourcesModel> {
        return apiRequestSources(urlReq)
    }
    
    func fetchNewsWithSources(_ page: Int, _ source: String) -> Observable<ENewsModel> {
        return apiRequestEverything(urlReq)
    }
    
    func fetchTHNews(_ page: Int, _ category: THCategories) -> Observable<THNewsModel> {
        return apiRequestTH(urlReq)
    }
    
    func fetch(_ page: Int) -> Observable<ENewsModel> {
        return apiRequestEverything(urlReq)
    }
    
    func apiRequestEverything(_ urlRequest: URLRequest) -> Observable<ENewsModel> {
        return Observable<ENewsModel>.create {
            observer in
            observer.onNext(self.eNews!)
            observer.onCompleted()
            return Disposables.create {
            }
        }
    }
    
    func apiRequestTH(_ urlRequest: URLRequest) -> Observable<THNewsModel> {
        return Observable<THNewsModel>.create {
            observer in
            observer.onNext(self.thNews!)
            observer.onCompleted()
            return Disposables.create {
            }
        }
    }
    
    func apiRequestSources(_ urlRequest: URLRequest) -> Observable<SourcesModel> {
        return Observable<SourcesModel>.create {
            observer in
            observer.onNext(self.sources!)
            observer.onCompleted()
            return Disposables.create {
            }
        }
    }
    
    
    
    
}
