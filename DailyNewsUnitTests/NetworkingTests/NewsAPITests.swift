//
//  NewsAPITests.swift
//  DailyNewsUnitTests
//
//  Created by Latif Atci on 6/9/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import XCTest
@testable import DailyNews

class NewsAPITests: XCTestCase {

    var newsAPIFetch: NewsAPI!
    var newsAPISearch: NewsAPI!
    var newsAPIwithSources: NewsAPI!
    var newsAPISources: NewsAPI!
    var newsAPITopHeadline: NewsAPI!
    
    override func setUp() {
        newsAPIFetch = NewsAPI.fetch(1)
        newsAPISearch = NewsAPI.fetchDataForSearchController("query", 2)
        newsAPIwithSources = NewsAPI.fetchNewsWithSources(3, "source")
        newsAPISources = NewsAPI.fetchSources(.init(category: .science, language: "en", country: nil))
        newsAPITopHeadline = NewsAPI.fetchTHNews(4, .sports)
    }

    override func tearDown() {
        newsAPITopHeadline = nil
        newsAPIFetch = nil
        newsAPIwithSources = nil
        newsAPISources = nil
        newsAPISearch = nil
    }

    func testNewsAPICreatesURLString() {
        
        XCTAssertEqual(newsAPIFetch.createUrlString(), "https://newsapi.org/v2/everything")
        XCTAssertEqual(newsAPISearch.createUrlString(), "https://newsapi.org/v2/everything")
        XCTAssertEqual(newsAPIwithSources.createUrlString(), "https://newsapi.org/v2/everything")
        XCTAssertEqual(newsAPISources.createUrlString(), "https://newsapi.org/v2/sources")
        XCTAssertEqual(newsAPITopHeadline.createUrlString(), "https://newsapi.org/v2/top-headlines")
    }
    
}
