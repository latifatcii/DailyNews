//
//  NewsCell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/13/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class BusinessCell: UICollectionViewCell {
    
    let feed = BusinessSectionController()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(feed.view)
        feed.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
