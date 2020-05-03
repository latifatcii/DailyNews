//
//  ENewsArticlesRepsonses.swift
//  DailyNews
//
//  Created by Latif Atci on 5/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation

struct ENewsArticlesResponses: Decodable {
    private enum RootCodingKeys: String, CodingKey {
        case articles
    }
    
    let articles: [EArticle]
    
    init(_ articles: [EArticle]) {
        self.articles = articles
    }
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)

        self.articles = try rootContainer.decode([EArticle].self, forKey: .articles)
    }
}
