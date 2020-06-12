//
//  SectionsHeaderViewModelTests.swift
//  DailyNewsUnitTests
//
//  Created by Latif Atci on 6/12/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import XCTest
@testable import DailyNews

class SectionsHeaderViewModelTests: XCTestCase {

    var service: MockNewsService!
    var viewModel: SectionsHeaderViewModel!
    override func setUp() {
        service = MockNewsService()
        viewModel = SectionsHeaderViewModel(service, .business)
    }
    
    override func tearDown() {
        service = nil
        viewModel = nil
    }
    
    func testNewsHeaderViewModelFetchsNewsWhenInitialized() throws {
        
        //Given
        let news = try ResourceLoader.loadTH(resource: .fetchTH2)
        service.thNews = news
        let presentationNews = news.articles.map {
            TopHeadlinePresentation.init(topHeadline: $0)
        }
        
        //When
        viewModel.loadingTrigger.onNext(())
        
        //Then
        XCTAssertEqual(try viewModel.sectionHeaderNews.toBlocking().first(), presentationNews)
    }

}
