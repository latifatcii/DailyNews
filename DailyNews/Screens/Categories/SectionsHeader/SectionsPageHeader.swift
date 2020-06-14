//
//  SectionsPageHeader.swift
//  DailyNews
//
//  Created by Latif Atci on 3/7/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import TinyConstraints

class SectionsPageHeader: UICollectionReusableView {
    
    var category: THCategories? {
        didSet {
            if let category = category {
                let feedHeaderController = SectionsHeaderController(SectionsHeaderViewModel())
                self.addSubview(feedHeaderController.view)
                feedHeaderController.view.edgesToSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
