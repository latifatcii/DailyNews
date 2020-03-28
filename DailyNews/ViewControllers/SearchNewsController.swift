//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class SearchNewsController : UIViewController {
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchController()
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
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func searchNews(q : String , page : Int) {
        FetchNews.shared.fetchDataForSearchController(ERequest(q: q, qInTitle: nil, domains: nil, excludeDomains: nil, from: nil, to: nil, language: "en", sortBy: nil, pageSize: 50, page: page)) { (result) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
            }
            switch result {
            case .success(let news):
                if news.articles.count < 50 {
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
        let article = news[indexPath.item]
        let time = article.publishedAt.convertToDisplayFormat()
        cell.headerLabel.text = article.title
        cell.timeLabel.text = time
        cell.sourceLabel.text = article.source.name
        cell.newsImageView.sd_setImage(with: URL(string: article.urlToImage ?? ""))
        
        return cell
    }
    
    
    
}

extension SearchNewsController :  UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        page = 1
        activityIndicatorView.startAnimating()
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
