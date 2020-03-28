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
                let time = news.publishedAt.convertToDisplayFormat()
                headerLabel.text = news.title
                timeLabel.text = time
                sourceLabel.text = news.source.name
                newsImageView.sd_setImage(with: URL(string: news.urlToImage ?? ""))

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(headerLabel)
        addSubview(newsImageView)
        addSubview(timeLabel)
        
//        newsImageView.image = UIImage(named: "clem")
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.clipsToBounds = true
        
        headerLabel.text = "Ilker Kaleli iddiali diziyle geri dondu ! Ilker Kaleli iddiali diziyle geri dondu"
        headerLabel.textColor = .darkGray
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = .systemFont(ofSize: 18)
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.numberOfLines = 0
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "5 Minutes Ago"
        timeLabel.textColor = .lightGray
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.font = .systemFont(ofSize: 12)
        
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.textColor = .systemGray
        sourceLabel.adjustsFontSizeToFitWidth = true
        sourceLabel.font = .systemFont(ofSize: 12)
        sourceLabel.text = "Hurriyet.com.tr"
        
        
        let horizontalStackView = UIStackView(arrangedSubviews: [timeLabel,sourceLabel])
        horizontalStackView.distribution = .equalSpacing
        
        let labelStackView = UIStackView()
        addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(headerLabel)
        labelStackView.addArrangedSubview(horizontalStackView)
        labelStackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ),
            newsImageView.heightAnchor.constraint(equalToConstant: 130),
            
            labelStackView.topAnchor.constraint(equalTo: newsImageView.bottomAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    

}
