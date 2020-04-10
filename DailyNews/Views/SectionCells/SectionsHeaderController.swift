//
//  FeedHeaderCell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/7/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class SectionsHeaderController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var news : [THArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SectionsHeaderCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let safariVC = SFSafariViewController(url: URL(string: news[indexPath.item].url)!)
        self.view.window?.rootViewController?.present(safariVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SectionsHeaderCell
            else {
                return UICollectionViewCell()
        }
        let article = news[indexPath.item]
        cell.news = article
        cell.scrollIndicator.currentPage = indexPath.item
        return cell
    }
}
