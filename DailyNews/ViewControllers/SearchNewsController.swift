//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class SearchNewsController : UIViewController {
    
    let cellId = "cellId"
    var collectionView : UICollectionView!
    var news : [EArticle] = []
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicatorView)

        activityIndicatorView.fillSuperview()
        configureSearchController()
        configureCollectionView()
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
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
    
    func searchNews(q : String) {
        activityIndicatorView.startAnimating()
        FetchNews.shared.fetchDataForSearchController(ERequest(q: q, qInTitle: nil, domains: nil, excludeDomains: nil, from: nil, to: nil, language: "en", sortBy: nil, pageSize: 50, page: nil)) { (result) in
            switch result {
            case .success(let news):
                self.news = news.articles
                DispatchQueue.main.async {
                 self.activityIndicatorView.stopAnimating()
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
        print(news.count)

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

extension SearchNewsController : UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text , !filter.isEmpty else { return }
        
        searchNews(q: filter)
        print("news count search controller \(news.count)")
        
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        news.removeAll()
        collectionView.reloadData()
    }
    
    
    
}
