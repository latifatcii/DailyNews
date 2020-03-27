//
//  FeedHeaderCell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/7/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SDWebImage

class NewsHeaderController: BaseListController , UICollectionViewDelegateFlowLayout {
    

    let cellId = "cellId"
    var news : [THArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(NewsHeaderCell.self, forCellWithReuseIdentifier: cellId)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let newsDetailsVC = NewsDetailsViewController()
        newsDetailsVC.url = URL(string: news[indexPath.item].url)
        newsDetailsVC.modalPresentationStyle = .overFullScreen
        present(newsDetailsVC , animated: true)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsHeaderCell
        cell.newsImageView.sd_setImage(with: URL(string :news[indexPath.item].urlToImage ?? "" ))
        cell.scrollIndicator.currentPage = indexPath.item
        cell.headerLabel.text = news[indexPath.item].title
        return cell
    }
    
    
    
    
    
    
}

