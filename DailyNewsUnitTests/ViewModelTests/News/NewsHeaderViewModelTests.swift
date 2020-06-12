//
//  NewsHeaderViewModelTests.swift
//  DailyNewsUnitTests
//
//  Created by Latif Atci on 6/12/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import XCTest
@testable import DailyNews

class NewsHeaderViewModelTests: XCTestCase {

    var service: MockNewsService!
    var viewModel: NewsHeaderViewModel!
    override func setUp() {
        service = MockNewsService()
        viewModel = NewsHeaderViewModel(service)
    }
    
    override func tearDown() {
        service = nil
        viewModel = nil
    }
    
    func testNewsHeaderViewModelFetchsNewsWhenInitialized() throws {
        
        //Given
        let news = try ResourceLoader.loadEverything(resource: .fetchNews2)
        service.eNews = news
        let presentationNews = news.articles.map {
            EverythingPresentation.init(everything: $0)
        }
                
        //When
        viewModel.loadPageTrigger.onNext(())
        
        //Then
        XCTAssertEqual(try viewModel.news.toBlocking().first(), presentationNews)
    }

}
