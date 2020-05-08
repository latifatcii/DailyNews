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
import RxDataSources

class NewsViewController: UIViewController {
    
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    let newsCellId = "newsCellId"
    let headerNewsCellId = "headerCellId"
    var page = 2
    var hasMoreNews = true
    let activityIndicatorView = UIActivityIndicatorView(color: .black)
    let refreshControl = UIRefreshControl()
    
    let viewModel: NewsViewModel
    let disposeBag = DisposeBag()
    
    init(_ viewModel: NewsViewModel = NewsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        collectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .lightGray
        activityIndicatorView.edgesToSuperview()
        setupBinding()
    }
    
    func setupBinding() {
        viewModel.loading.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.loadPageTrigger.onNext(())
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.loadPageTrigger)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<PresentationSection>(configureCell: {
            (ds, cv, ip, item) in
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: self.newsCellId, for: ip) as? SectionsCell else { return UICollectionViewCell() }
            cell.newsEverything = item
            return cell
        }, configureSupplementaryView: {
            (a, collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerNewsCellId, for: indexPath) as? NewsPageHeader else { return UICollectionReusableView() }
            
            return header
        })
        
        
        viewModel.newsForCells
            .observeOn(MainScheduler.instance)
            .map({
                items in [PresentationSection(header: "", items: items)]
            })
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
        .disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom
            .bind(to: viewModel.loadNextPageTrigger)
        .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(EverythingPresentation.self)
            .subscribe(onNext: { [weak self]
                news in
                guard let self = self else { return }
                let safariVC = SFSafariViewController(url: URL(string: news.url)!)
                self.present(safariVC, animated: true)
            })
        .disposed(by: disposeBag)
        
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.register(SectionsCell.self, forCellWithReuseIdentifier: newsCellId)
        collectionView.register(NewsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerNewsCellId)
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
    
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
