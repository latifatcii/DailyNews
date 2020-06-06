//
//  NewsAPI.swift
//  DailyNews
//
//  Created by Latif Atci on 6/7/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation

enum NewsAPI {
    case fetchDataForSearchController(_ searchedQuery: String, _ page: Int)
    case fetchNewsWithSources(_ page: Int, _ source: String)
    case fetchTHNews(_ page: Int, _ category: THCategories)
    case fetch(_ page: Int)
    case fetchSources(_ from: SRequest)
}

extension NewsAPI: APISetting {
    var path: String {
        switch self {
        case .fetch(_):
            return EndPointType.everything.rawValue
        case .fetchDataForSearchController(_, _):
            return EndPointType.everything.rawValue
        case .fetchNewsWithSources(_, _):
            return EndPointType.everything.rawValue
        case .fetchTHNews(_, _):
            return EndPointType.topHeadline.rawValue
        case .fetchSources(_):
            return EndPointType.sources.rawValue
            
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .fetchDataForSearchController(let query, let page):
            return ["page" : page, "pageSize": 10, "language": "en", "q": query]
        case .fetchNewsWithSources(let page, let source):
            return ["sources" : source, "pageSize": 10, "page": page, "language": "en"]
        case .fetchTHNews(let page, let category):
            return ["country" : "us", "pageSize": 10, "page": page, "category": category]
        case .fetch(let page):
            return ["page" : page, "pageSize": 10, "language": "en", "sources": Constants.sourcesIds, "sortBy": ESortBy.publishedAt]
        case .fetchSources(let sources):
            return ["category" : sources.category!, "language": sources.language!]
        }
    }
    
    
}
