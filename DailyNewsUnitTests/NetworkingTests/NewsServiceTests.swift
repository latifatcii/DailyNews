//
//  NewsServiceTests.swift
//  DailyNewsUnitTests
//
//  Created by Latif Atci on 6/9/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import XCTest

@testable import DailyNews

class NewsServiceTests: XCTestCase {

    func testParsing() throws {
        let bundle = Bundle(for: NewsServiceTests.self)
        let url = bundle.url(forResource: "fetchNews", withExtension: "json")
        let data = try Data(contentsOf: url!)
        let decoder = JSONDecoder()
        let fetchNews = try decoder.decode(ENewsModel.self, from: data)
        
        XCTAssertEqual(fetchNews.status, "ok")
        XCTAssertEqual(fetchNews.totalResults, 3322)
        XCTAssertEqual(fetchNews.articles.count, 2)
        XCTAssertEqual(fetchNews.articles[0].author, "Aayush Jindal")
        
    }
    
}
