//
//  CategoriesCell.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class CategoriesCell : UICollectionViewCell {
    
    var categoryLabel : UILabel = {
        let lb = UILabel()
        lb.adjustsFontSizeToFitWidth = true
        lb.font = .boldSystemFont(ofSize: 24)
        lb.textColor = .white
        return lb
    }()
    var categoryImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(categoryImageView)
        categoryImageView.addSubview(categoryLabel)
        
        categoryImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        categoryLabel.anchor(top: nil, leading: leadingAnchor, bottom: categoryImageView.bottomAnchor, trailing: trailingAnchor,size: .init(width: 0, height: 30))
        
        
        
    }
}
