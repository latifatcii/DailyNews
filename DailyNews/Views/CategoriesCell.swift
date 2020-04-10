//
//  CategoriesCell.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class CategoriesCell: UICollectionViewCell {

    var categoryLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    var categoryImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleToFill
        return imageV
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
        categoryLabel.anchor(top: nil, leading: leadingAnchor, bottom: categoryImageView.bottomAnchor,
                             trailing: trailingAnchor, size: .init(width: 0, height: 30))
    }
}
