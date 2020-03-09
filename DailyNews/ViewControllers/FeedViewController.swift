//
//  FeedViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class FeedViewController : UIViewController , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    let layout = UICollectionViewFlowLayout()
    var headerNews : THNews?
    var news : THNews?
    var collectionView : UICollectionView!
    let feedCellId = "feedCellId"
    let headerCellId = "headerCellId"
    var page = 2
    var hasMoreNews = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchNews()
        
        
        
        
    }
    
    func fetchNews() {
        

        let dispatchGroup = DispatchGroup()
        var headerGroup : THNews?
        var group : THNews?
        
        dispatchGroup.enter()
        FetchTopHeadline.shared.fetchData(THRequest(country: "tr", category: .unknown, q: nil, pageSize: 10, page: 2)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                if news.articles.count < 10 {
                    self.hasMoreNews = false
                }
                group = news
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        FetchTopHeadline.shared.fetchData(THRequest(country: "tr", category: .unknown, q: nil, pageSize: 5, page: 1)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                headerGroup = news
            case .failure(let err):
                print(err.localizedDescription)
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.headerNews = headerGroup
            self.news = group
            self.collectionView.reloadData()
            
        }
    }
    
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView.register(FeedPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        view.addSubview(collectionView)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! FeedPageHeader
        header.feedHeaderController.news = self.headerNews
        header.feedHeaderController.collectionView.reloadData()
        return header
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! FeedCell
        
        if let article = news?.articles[indexPath.item] {
            
            let time = article.publishedAt.convertToDisplayFormat()
            cell.headerLabel.text = article.title
            cell.timeLabel.text = time
            cell.sourceLabel.text = article.source.name
            cell.newsImageView.downloadImage(from: article.urlToImage ?? "")
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width, height: view.frame.width / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            print("yes")
            
        }
    }
    
    
}
