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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchNews()
        
        
        
        
    }
    
    func fetchNews() {
        

        FetchTopHeadline.shared.fetchData(THRequest(country: "tr", category: .unknown, q: nil, pageSize: 10, page: 2)) { (result) in
            switch result {
                
            case .success(let news):
                self.news = news
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                print(news.articles.count)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        FetchTopHeadline.shared.fetchData(THRequest(country: "tr", category: .unknown, q: nil, pageSize: 5, page: 1)) { (result) in
            switch result {
            case .success(let news):
                self.headerNews = news
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
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
    
    
}
