//
//  Searchcell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/27/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SDWebImage
import TinyConstraints

class SearchCell: UICollectionViewCell {

    var newsImageView: UIImageView = {
        let imageV = UIImageView(frame: .zero)
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 10
        return imageV
    }()
    var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18)
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
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    var news: EArticle? {
        didSet {
            if let news = news {
                if let newsImageUrl = news.urlToImage {
                let time = news.publishedAt.getTimeAgo()
                headerLabel.text = news.title
                timeLabel.text = time
                sourceLabel.text = news.source.name
                    if newsImageUrl != "null" {
                        newsImageView.sd_setImage(with: URL(string: newsImageUrl))
                    } else {
                        newsImageView.image = UIImage(named: "placeholderNews")
                    }
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupViews()
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

        newsImageView.edgesToSuperview(excluding: .bottom)
        newsImageView.height(130)
        
        labelStackView.edgesToSuperview(excluding: .top, insets: .left(5))
        labelStackView.topToBottom(of: newsImageView)
        
    }
}
