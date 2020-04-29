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
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {

    let layout = UICollectionViewFlowLayout()
    var news: PublishSubject<[EverythingPresentation]> = PublishSubject()
    var headerNews: PublishSubject<[EverythingPresentation]> = PublishSubject()
    var sources: [Sources] = []
    var collectionView: UICollectionView!
    let newsCellId = "newsCellId"
    let headerNewsCellId = "headerCellId"
    var page = 2
    var hasMoreNews = true
    let activityIndicatorView = UIActivityIndicatorView(color: .black)
    
    let viewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.edgesToSuperview()
        setupBinding()
        viewModel.fetchNews()

    }
    
    func setupBinding() {
        viewModel.loading.asObserver()
            .observeOn(MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.newsForCells
            .observeOn(MainScheduler.instance)
        .bind(to: news)
        .disposed(by: disposeBag)
        
        news.bind(to: collectionView.rx.items(cellIdentifier: newsCellId, cellType: SectionsCell.self)) {
            (row, news, cell) in
            cell.newsEverything = news
        }.disposed(by: disposeBag)
        
        viewModel.newsForHeader
            .observeOn(MainScheduler.instance)
        .bind(to: headerNews)
        .disposed(by: disposeBag)
        
//        headerNews.bind(to: collectionView.rx.items(cellIdentifier: headerNewsCellId, cellType: NewsPageHeader.self))
        
    }
    

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.delegate = self
//        collectionView.dataSource = self
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
//            self.headerNews = headerGroup
//            self.news.append(contentsOf: group)
            self.collectionView.reloadData()
        }
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {


//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerNewsCellId, for: indexPath) as? NewsPageHeader else { return UICollectionReusableView() }
////        header.feedHeaderController.news = self.headerNews
//        header.feedHeaderController.collectionView.reloadData()
//        return header
//    }

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

}
