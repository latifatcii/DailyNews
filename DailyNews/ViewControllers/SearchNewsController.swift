//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SafariServices

class SearchNewsController: UIViewController {
    var timer: Timer?
    let cellId = "cellId"
    var collectionView: UICollectionView!
    var news: [EArticle] = []
    var page = 1
    var hasMoreNews = true
    var searchedText: String = ""
    let activityIndicatorView = UIActivityIndicatorView(color: .black)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
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
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor)
    }

    func searchNews(qWord: String, page: Int) {
        activityIndicatorView.startAnimating()
        FetchNews.shared.fetchDataForSearchController(ERequest(qWord: qWord, qInTitle: nil, domains: nil,
                                                               excludeDomains: nil, fromDate: nil, toDate: nil, language: "en",
                                                               sortBy: nil, pageSize: 10, page: page, sources: nil)) { (result) in
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
        let safariVC = SFSafariViewController(url: URL(string: news[indexPath.item].url)!)
        present(safariVC, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            guard hasMoreNews else { return }
            page += 1
            searchNews(qWord: searchedText, page: page)
        }
    }
}

extension SearchNewsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchCell
            else { return UICollectionViewCell() }
        cell.news = self.news[indexPath.item]
        return cell
    }
}

extension SearchNewsController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        page = 1
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.news.removeAll()
            let searchedText = searchText.replacingOccurrences(of: " ", with: "-")
            self.searchNews(qWord: searchedText, page: self.page)
            self.searchedText = searchedText
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        news.removeAll()
        page = 1
        collectionView.reloadData()
    }
}
