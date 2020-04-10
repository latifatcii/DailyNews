//
//  Constants.swift
//  DailyNews
//
//  Created by Latif Atci on 4/6/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation

class Constants {
    
    static let sourcesIds = "abc-news,abc-news-au,aftenposten,al-jazeera-english,ansa,ary-news,associated-press,axios,bbc-news,bild,blasting-news-br,breitbart-news,cbc-news,cbs-news,cnn,cnn-es,der-tagesspiegel,el-mundo,focus,fox-news,globo,google-news,google-news-ar,google-news-au,google-news-br,google-news-ca,google-news-fr,google-news-in,google-news-is,google-news-it,google-news-ru,google-news-sa,google-news-uk,goteborgs-posten,independent,infobae,la-gaceta,la-nacion,la-repubblica,le-monde,lenta,liberation,msnbc,national-review,nbc-news,news24,news-com-au,newsweek,new-york-magazine,nrk,politico,rbc,reddit-r-all,reuters,rt,rte,rtl-nieuws,sabq,spiegel-online,svenska-dagbladet,the-american-conservative,the-globe-and-mail,the-hill,the-hindu,the-huffington-post,the-irish-times,the-jerusalem-post,the-times-of-india,the-washington-post,the-washington-times,time,usa-today,vice-news,xinhua-net,ynet,"
    
    static let listOfCategories = [FeaturedCategoryController(),BusinessCategoryController(),SportsCategoryController(),TechnologyCategoryController(),
                                   ScienceCategoryController(),EntertainmentCategoryController(),HealthCategoryController()]
    
    static let categoryImageNames = ["featured","business","sports","technology","science","entertainment","health"]
    
    static let categoryNames = ["Featured","Business","Sports","Technology","Science","Entertainment","Health"]

    
}
