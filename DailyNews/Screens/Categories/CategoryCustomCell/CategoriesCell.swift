//
//  CategoriesCell.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import TinyConstraints

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
        categoryImageView.edgesToSuperview()
        categoryLabel.leadingToSuperview()
        categoryLabel.trailingToSuperview()
        categoryLabel.height(30)
        categoryLabel.bottom(to: categoryImageView)
    }
}
