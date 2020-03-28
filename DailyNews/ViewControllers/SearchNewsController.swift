//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class SearchNewsController : UIViewController {
    
    var refresher = UIRefreshControl()
    var timer : Timer?
    let cellId = "cellId"
    var collectionView : UICollectionView!
    var news : [EArticle] = []
    var page = 1
    var hasMoreNews = true
    var searchedText : String = ""
    
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        collectionView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(refreshNews), for: .valueChanged)


        
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a news"
        navigationItem.searchController = searchController
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    @objc private func refreshNews() {
        news.removeAll()
        page = 1
        searchNews(q: searchedText, page: page)
        self.refresher.endRefreshing()

    }
    
    func searchNews(q : String , page : Int) {
        activityIndicatorView.startAnimating()
        FetchNews.shared.fetchDataForSearchController(ERequest(q: q, qInTitle: nil, domains: nil, excludeDomains: nil, from: nil, to: nil, language: "en", sortBy: nil, pageSize: 10, page: page)) { (result) in
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
    
}

extension SearchNewsController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.news = self.news[indexPath.item]
        return cell
    }
}

extension SearchNewsController :  UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        page = 1
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.news.removeAll()
            self.searchNews(q: searchText, page: self.page)
            self.searchedText = searchText
        })
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        news.removeAll()
        page = 1
        collectionView.reloadData()

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
            searchNews(q: searchedText, page: page)
            
        }
    }

}
