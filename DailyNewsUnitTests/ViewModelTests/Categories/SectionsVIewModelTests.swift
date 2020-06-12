//
//  SectionsVIewModelTests.swift
//  DailyNewsUnitTests
//
//  Created by Latif Atci on 6/12/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import XCTest
@testable import DailyNews

class SectionsVIewModelTests: XCTestCase {

    var service: MockNewsService!
    var viewModel: SectionsViewModel!
    
    override func setUp() {
        service = MockNewsService()
        viewModel = SectionsViewModel(service, .general)
    }
    
    override func tearDown() {
        service = nil
        viewModel = nil
    }
    
    func testViewModelFetchDataWhenInitialized() throws {
        
        //Given
        let news = try ResourceLoader.loadTH(resource: .fetchTH)
        service.thNews = news
        let presentationNews = news.articles.map {
            new in TopHeadlinePresentation(topHeadline: new)
        }
        //When
        viewModel.loadTrigger.onNext(())
        
        
        //Then
        XCTAssertEqual(try viewModel.news.toBlocking().first(), presentationNews)
    }
    
    func testViewModelLoadNextPageWhenPageScrolledDown() throws {
        
        //Given
        let page = 3
        let news = try ResourceLoader.loadTH(resource: .fetchTH)
        service.thNews = news
        var presentationNews = news.articles.map {
            new in TopHeadlinePresentation(topHeadline: new)
        }
        presentationNews.append(contentsOf: presentationNews)

        
        //When
        viewModel.loadTrigger.onNext(())
        viewModel.nextPageLoadTrigger.onNext(())
        
        //Then
        XCTAssertEqual(viewModel.page, page)
        XCTAssertEqual(try viewModel.news.toBlocking().first(), presentationNews)
    }

}
