//
//  NewsViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SafariServices
import TinyConstraints

class NewsViewController: UIViewController {

    let layout = UICollectionViewFlowLayout()
    var news: [EArticle] = []
    var headerNews: [EArticle] = []
    var sources: [Sources] = []
    var collectionView: UICollectionView!
    let newsCellId = "newsCellId"
    let headerNewsCellId = "headerCellId"
    var page = 2
    var hasMoreNews = true
    let activityIndicatorView = UIActivityIndicatorView(color: .black)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.edgesToSuperview()
        fetchNews(page: page)
        activityIndicatorView.startAnimating()

    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SectionsCell.self, forCellWithReuseIdentifier: newsCellId)
        collectionView.register(NewsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerNewsCellId)
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }

    func fetchNews(page: Int) {
        let dispatchQueue = DispatchQueue(label: "com.latifatci.DailyNews", qos: .background, attributes: .concurrent)
        let dispatchGroup = DispatchGroup()
        var headerGroup: [EArticle] = []
        var group: [EArticle] = []
        activityIndicatorView.startAnimating()

        dispatchGroup.enter()
        dispatchQueue.async {
            FetchNews.shared.fetchNewsFromEverything(ERequest(qWord: nil, qInTitle: nil, domains: nil, excludeDomains: nil, fromDate: nil, toDate: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: 1, sources: Constants.sourcesIds)) { (result) in
                switch result {
                case .success(let news):
                    headerGroup = news.articles
                case .failure(let err):
                    print(err)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        dispatchQueue.async {
            FetchNews.shared.fetchNewsFromEverything(ERequest(qWord: nil, qInTitle: nil, domains: nil, excludeDomains: nil, fromDate: nil, toDate: nil, language: "en", sortBy: .publishedAt, pageSize: 10, page: page, sources: Constants.sourcesIds)) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let news):
                    if news.articles.count < 10 {
                        self.hasMoreNews = false
                    }
                    group.append(contentsOf: news.articles)
                case .failure(let err):
                    print(err)
                }
                dispatchGroup.leave()
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

extension NewsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as? SectionsCell
            else { return UICollectionViewCell() }
        cell.newsEverything = news[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerNewsCellId, for: indexPath) as? NewsPageHeader else { return UICollectionReusableView() }
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
            guard hasMoreNews else { return }
            page += 1
            fetchNews(page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2 )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: URL(string: news[indexPath.item].url)!)
        present(safariVC, animated: true)
    }
}
