//
//  FeedCell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {

    
    var collectionView : UICollectionView!
    let newsCellId = "newsCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: newsCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as! NewsCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    
    
    
}

class NewsCell: UICollectionViewCell {
    
    let newsImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        newsImageView.image = UIImage(named: "austin")


        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor ),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
}


class NewsCell2 : FeedCell {
    
    fileprivate let newsDetailCellId = "newsDetailCellId"
    

    
    override func configureCollectionView() {

        super.configureCollectionView()
        collectionView.register(NewsDetailCell.self, forCellWithReuseIdentifier: newsDetailCellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsDetailCellId, for: indexPath) as! NewsDetailCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    
    fileprivate class NewsDetailCell : NewsCell {

        fileprivate let headerLabel = UILabel(frame: .zero)
        fileprivate let timeLabel = UILabel(frame: .zero)
        
        fileprivate override func setupViews() {
            addSubview(headerLabel)
            addSubview(newsImageView)
            addSubview(timeLabel)
            
            newsImageView.image = UIImage(named: "clem")
            newsImageView.translatesAutoresizingMaskIntoConstraints = false
            newsImageView.layer.cornerRadius = 10
            newsImageView.clipsToBounds = true
            
            headerLabel.text = "Ilker Kaleli iddiali diziyle geri dondu!asdadasdadas"
            headerLabel.textColor = .black
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            headerLabel.font = .systemFont(ofSize: 23, weight: .medium)

            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.text = "5 Minutes Ago"
            timeLabel.textColor = .lightGray
            timeLabel.font = .systemFont(ofSize: 12, weight: .regular)
            
            let labelStackView = UIStackView()
            addSubview(labelStackView)
            labelStackView.translatesAutoresizingMaskIntoConstraints = false
            labelStackView.addArrangedSubview(headerLabel)
            labelStackView.addArrangedSubview(timeLabel)
            labelStackView.distribution = .fillEqually
            labelStackView.spacing = 15
            labelStackView.axis = .vertical

            NSLayoutConstraint.activate([
                newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor ),
                newsImageView.heightAnchor.constraint(equalToConstant: 240),
                
                labelStackView.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
                labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                labelStackView.heightAnchor.constraint(equalToConstant: 55)

            ])
            
            
        }
        
        
        
        
    }
    
}
