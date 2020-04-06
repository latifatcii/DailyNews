//
//  NewsViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController : UIViewController {

    let layout = UICollectionViewFlowLayout()
    var news : [EArticle] = []
    var headerNews : [EArticle] = []
    var sources : [Sources] = []
    var collectionView : UICollectionView!
    let newsCellId = "newsCellId"
    let headerNewsCellId = "headerCellId"
    var page = 2
    var hasMoreNews = true

    let activityIndicatorView = UIActivityIndicatorView(color: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        fetchNews(page: page)
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SectionsCell.self, forCellWithReuseIdentifier: newsCellId)
        collectionView.register(NewsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNewsCellId)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }

    
    func fetchNews(page : Int) {
        let dispatchGroup = DispatchGroup()
        var headerGroup : [EArticle] = []
        var group : [EArticle] = []
        
        activityIndicatorView.startAnimating()
        
        dispatchGroup.enter()
        FetchNews.shared.fetchNewsFromEverything(ERequest(q: nil, qInTitle: nil, domains: nil, excludeDomains: nil, from: nil, to: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: 1, sources: Constants.sourcesIds)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                headerGroup = news.articles
            case .failure(let err):
                print(err)
            }
        }
        dispatchGroup.enter()
        FetchNews.shared.fetchNewsFromEverything(ERequest(q: nil, qInTitle: nil, domains: nil, excludeDomains: nil, from: nil, to: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: page, sources: Constants.sourcesIds)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let news):
                if news.articles.count < 10 {
                    self.hasMoreNews = false
                }
                group.append(contentsOf: news.articles)
            case .failure(let err):
                print(err)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            self.headerNews = headerGroup
            self.news.append(contentsOf: group)
            self.collectionView.reloadData()
        }
    }
}

extension NewsViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as! SectionsCell
        
        cell.newsEverything = news[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerNewsCellId, for: indexPath) as! NewsPageHeader
        header.feedHeaderController.news = self.headerNews
        header.feedHeaderController.collectionView.reloadData()
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width, height: view.frame.width / 1.2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sf = SFSafariViewController(url: URL(string: news[indexPath.item].url)!)
        present(sf , animated: true)
        
    }
}
