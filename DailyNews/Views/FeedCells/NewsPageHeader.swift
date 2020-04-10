//
//  NewsPageHeader.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import TinyConstraints

class NewsPageHeader: UICollectionReusableView {

    let feedHeaderController = NewsHeaderController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(feedHeaderController.view)
        feedHeaderController.view.edgesToSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
