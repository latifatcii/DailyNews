//
//  FeedViewController.swift
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

class FeaturedCategoryController: UIViewController {
    
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    let feedCellId = "feedCellId"
    let headerCellId = "headerCellId"
    let activityIndicatorView = UIActivityIndicatorView(color: .black)
    var viewModel: SectionsViewModel
    var category: THCategories
    let disposeBag = DisposeBag()
    
    init(_ viewModel: SectionsViewModel = SectionsViewModel(NewsService(), THCategories.general), _ category: THCategories = .general) {
        self.category = category
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
        activityIndicatorView.edgesToSuperview()
        setupBinding()
    }
    
    func setupBinding() {
        viewModel.loading.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.loadPageTrigger.onNext(())
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<TopHeadlinePresentationSection>(configureCell: { [weak self]
            (ds, cv, ip, news) in
            guard let self = self else { fatalError() }
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: self.feedCellId, for: ip) as? SectionsCell else { return UICollectionViewCell() }
            cell.news = news
            return cell
        }, configureSupplementaryView: {
            (a, collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerCellId, for: indexPath) as? SectionsPageHeader else { return UICollectionReusableView() }
            header.category = self.category
            
            return header
            
        })
        
        viewModel.news
            .observeOn(MainScheduler.instance)
            .map {
                news in [TopHeadlinePresentationSection(items: news)]
        }
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom
            .bind(to: viewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(TopHeadlinePresentation.self)
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
        collectionView.register(SectionsCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView.register(SectionsPageHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
}

extension FeaturedCategoryController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2)
    }
}
