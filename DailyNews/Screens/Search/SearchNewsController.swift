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
    
}
