//
//  Searchcell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/27/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCell : UICollectionViewCell {
    
    let newsImageView = UIImageView(frame: .zero)
    let headerLabel = UILabel(frame: .zero)
    let timeLabel = UILabel(frame: .zero)
    let sourceLabel = UILabel(frame: .zero)
    
    var news : EArticle? {
        didSet {
            if let news = news {
                let time = news.publishedAt.getTimeAgo()
                headerLabel.text = news.title
                timeLabel.text = time
                sourceLabel.text = news.source.name
                newsImageView.sd_setImage(with: URL(string: news.urlToImage ?? ""))

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
        
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 10
        
        headerLabel.textColor = .darkGray
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = .systemFont(ofSize: 18)
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.numberOfLines = 0
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .lightGray
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.font = .systemFont(ofSize: 12)
        
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.textColor = .systemGray
        sourceLabel.adjustsFontSizeToFitWidth = true
        sourceLabel.font = .systemFont(ofSize: 12)
        
        let horizontalStackView = UIStackView(arrangedSubviews: [timeLabel,sourceLabel])
        horizontalStackView.distribution = .equalSpacing
        
        let labelStackView = UIStackView()
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(headerLabel)
        labelStackView.addArrangedSubview(horizontalStackView)
        labelStackView.axis = .vertical
        
        newsImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 130))
        
        labelStackView.anchor(top: newsImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 0))
    }
}
