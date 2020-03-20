//
//  FeedViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class FeaturedSectionController : UIViewController , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    

    let layout = UICollectionViewFlowLayout()
    var news : [THArticle] = []
    var headerNews : [THArticle] = []
    var collectionView : UICollectionView!
    let feedCellId = "feedCellId"
    let headerCellId = "headerCellId"
    var page = 2
    var hasMoreNews = true
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        fetchNews(page: page)
    }


    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView.register(NewsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    

    
    func fetchNews(page : Int) {
        let dispatchGroup = DispatchGroup()
        var headerGroup : [THArticle] = []
        var group : [THArticle] = []
        activityIndicatorView.startAnimating()
        dispatchGroup.enter()

        FetchTopHeadline.shared.fetchData(THRequest(country: "us", category: .general, q: nil, pageSize: 10, page: page)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                if news.articles.count < 10 {
                    self.hasMoreNews = false
                }
                group.append(contentsOf: news.articles)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        dispatchGroup.enter()
        FetchTopHeadline.shared.fetchData(THRequest(country: "us", category: .general, q: nil, pageSize: 5, page: 1)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                headerGroup = news.articles
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            self.headerNews = headerGroup
            self.news.append(contentsOf: group)
            self.collectionView.reloadData()
            

        }
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! NewsPageHeader
        header.feedHeaderController.news = self.headerNews
        header.feedHeaderController.collectionView.reloadData()
        return header
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! NewsCell
        
        let article = news[indexPath.item]
        
        let time = article.publishedAt.convertToDisplayFormat()
        cell.headerLabel.text = article.title
        cell.timeLabel.text = time
        cell.sourceLabel.text = article.source.name
        cell.newsImageView.sd_setImage(with: URL(string: article.urlToImage ?? ""))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width, height: view.frame.width / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsDetailsVC = NewsDetailsViewController()
        newsDetailsVC.url = URL(string: news[indexPath.item].url)
        newsDetailsVC.modalPresentationStyle = .overFullScreen
        present(newsDetailsVC , animated: true)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreNews else {
                return
            }
                page += 1
                fetchNews(page : page)
            
        }
    }

    
    
}
