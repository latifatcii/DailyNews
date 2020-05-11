//
//  NewsCell.swift
//  DailyNews
//
//  Created by Latif Atci on 5/11/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    var newsImageView: UIImageView = {
        let imageV = UIImageView(frame: .zero)
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 10
        imageV.image = UIImage(named: "placeholderNews")
        return imageV
    }()
    var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    var sourceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    var newsEverything: EverythingPresentation? {
        didSet {
            if let newsEverything = newsEverything {
                if let newsImageUrl = newsEverything.urlToImage {
                    if newsImageUrl != "null"{
                        newsImageView.sd_setImage(with: URL(string: newsImageUrl))
                    } else {
                        newsImageView.image = UIImage(named: "placeholderNews")
                    }
                }
                let time = newsEverything.publishedAt.getTimeAgo()
                headerLabel.text = newsEverything.title
                timeLabel.text = time
                sourceLabel.text = newsEverything.source
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(headerLabel)
        addSubview(newsImageView)
        addSubview(timeLabel)
        let horizontalStackView = UIStackView(arrangedSubviews: [timeLabel, sourceLabel])
        horizontalStackView.distribution = .equalSpacing
        let labelStackView = UIStackView()
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(headerLabel)
        labelStackView.addArrangedSubview(horizontalStackView)
        labelStackView.axis = .vertical

        newsImageView.edgesToSuperview(excluding: .bottom, insets: .init(top: 5, left: 5, bottom: 5, right: 5))
        newsImageView.height(240)
        labelStackView.edgesToSuperview(excluding: .top, insets: .left(5))
        labelStackView.topToBottom(of: newsImageView)
    }
}
