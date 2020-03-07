//
//  FeedHeaderCell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/7/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class FeedHeaderController: BaseListController , UICollectionViewDelegateFlowLayout {
    

    let cellId = "cellId"
    var news : THNews?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedHeaderCell.self, forCellWithReuseIdentifier: cellId)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 2)
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news?.articles.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedHeaderCell
        cell.newsImageView.downloadImage(from: news?.articles[indexPath.item].urlToImage ?? "")
        return cell
    }
    
    
    
    
    
    
}

