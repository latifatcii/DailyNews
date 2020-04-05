//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/5/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SafariServices

class SourcesViewController : UIViewController {
    
    var sourceId : String!
    var collectionView : UICollectionView!
    var news : [EArticle] = []
    var page = 1
    var hasMoreNews = true
    let cellId = "cellId"

    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sourceId!)
        configureCollectionView()
        fetchNews(source: sourceId, page: 1)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func fetchNews(source : String , page : Int) {
        activityIndicatorView.startAnimating()
        FetchNews.shared.fetchNewsWithSources(ERequest(q: nil, qInTitle: nil, domains: nil, excludeDomains: nil, from: nil, to: nil, language: "en", sortBy: nil, pageSize: 10, page: page, sources: source)) { (result) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
            }
            switch result {
            case .success(let news):
                if news.articles.count < 10 {
                    self.hasMoreNews = false
                }
                self.news.append(contentsOf: news.articles)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sf = SFSafariViewController(url: URL(string: news[indexPath.item].url)!)
        present(sf , animated: true)
        
    }
    
}

extension SourcesViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.news = self.news[indexPath.item]
        return cell
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
            fetchNews(source: sourceId, page: page)
            
        }
    }

}
