//
//  SourcesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SafariServices
import TinyConstraints
import RxSwift
import RxCocoa
import RxDataSources

class SearchNewsController: UIViewController {
    let cellId = "cellId"
    var collectionView: UICollectionView!
    var searchedText: String = ""
    let activityIndicatorView = UIActivityIndicatorView(color: .black)
    let searchController = UISearchController()
    let viewModel = SearchNewsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.edgesToSuperview()
        setupBinding()
    }
    
    func setupBinding() {
        
        
        viewModel.loading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
       searchController.searchBar.rx.text
            .orEmpty
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .debug()
            .distinctUntilChanged()
            .bind(to: viewModel.searchText)
        .disposed(by: disposeBag)
        
        
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<PresentationSection>(configureCell: { [weak self]
            (ds, cv, ip, item) in
            guard let self = self else { fatalError() }
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: self.cellId, for: ip) as? SearchCell else { return UICollectionViewCell() }
            cell.news = item
            return cell
        })
        
        viewModel.searchedNews
            .observeOn(MainScheduler.instance)
            .map {
                items in [PresentationSection(header: "", items: items)]
        }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)

        collectionView.rx.reachedBottom
            .bind(to: viewModel.loadNextPageTrigger)
        .disposed(by: disposeBag)
        
    }
    
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a news"
        navigationItem.searchController = searchController
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let safariVC = SFSafariViewController(url: URL(string: news[indexPath.item].url)!)
//        present(safariVC, animated: true)
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//        if offsetY > contentHeight - height {
//            guard hasMoreNews else { return }
//            page += 1
////            searchNews(qWord: searchedText, page: page)
//        }
//    }
}

//extension SearchNewsController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return news.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SearchCell
//            else { return UICollectionViewCell() }
////        cell.news = self.news[indexPath.item]
//        return cell
//    }
//}

//extension SearchNewsController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        page = 1
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
//            self.news.removeAll()
//            let searchedText = searchText.replacingOccurrences(of: " ", with: "-")
//            if !searchedText.isEmpty {
////                self.searchNews(qWord: searchedText, page: self.page)
//                self.searchedText = searchedText
//            }
//        })
//    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        news.removeAll()
//        page = 1
//        collectionView.reloadData()
//    }


