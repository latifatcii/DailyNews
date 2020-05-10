//
//  TopHeadlinePresentation.swift
//  DailyNews
//
//  Created by Latif Atci on 4/27/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxDataSources

final class TopHeadlinePresentation {
    let source: String
    let author: String?
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    
    init(source: String, author: String?, title: String, url: String, urlToImage: String?, publishedAt: String) {
        self.source = source
        self.author = author
        self.title = title
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
    convenience init(topHeadline: THArticle) {
        self.init(source: topHeadline.source.name, author: topHeadline.author, title: topHeadline.title, url: topHeadline.url, urlToImage: topHeadline.urlToImage, publishedAt: topHeadline.publishedAt)
    }
}

struct TopHeadlinePresentationSection {
    var items: [TopHeadlinePresentation]
}

extension TopHeadlinePresentationSection: SectionModelType {
    init(original: TopHeadlinePresentationSection, items: [TopHeadlinePresentation]) {
        self = original
        self.items = items
    }
}
