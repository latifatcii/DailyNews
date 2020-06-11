//
//  ResourceLoader.swift
//  DailyNewsUnitTests
//
//  Created by Latif Atci on 6/11/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation

class ResourceLoader {
    
    enum NewsResource: String {
        case fetchNews
        case fetchTH
        case
    }
    
    static func loadNews<T: Decodable>(resource: NewsResource) throws -> T {
        
        let bundle = Bundle(for: ResourceLoader.self)
        let url = bundle.url(forResource: resource.rawValue, withExtension: "json")
        let data = try Data(contentsOf: url!)
        let decoder = JSONDecoder()
        let fetchNews = try decoder.decode(T.self, from: data)
        
        return fetchNews
    }
}
