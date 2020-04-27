//
//  EverythingPresentation.swift
//  DailyNews
//
//  Created by Latif Atci on 4/27/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation

final class EverythingPresentation {
    let source: String
    let author: String?
    let title: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    
    init(source: String, author: String?, title: String?, url: String, urlToImage: String?, publishedAt: String) {
        self.source = source
        self.author = author
        self.title = title
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
    convenience init(everything: EArticle) {
        self.init(source: everything.source.name, author: everything.author, title: everything.title, url: everything.url, urlToImage: everything.urlToImage, publishedAt: everything.publishedAt)
    }
}

