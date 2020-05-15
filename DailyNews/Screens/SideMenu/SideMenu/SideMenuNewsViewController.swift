//
//  SideMenuNewsViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/5/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SafariServices
import TinyConstraints
import RxSwift
import RxCocoa
import RxDataSources

class SideMenuNewsViewController: UIViewController {

    var sourceName: String!
    var sourceId: String!
    var collectionView: UICollectionView!
    let cellId = "cellId"
    let viewModel: SideMenuNewsViewModel
    let disposeBag = DisposeBag()
    
    init(_ viewModel: SideMenuNewsViewModel = SideMenuNewsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dismissButton: UIButton = {
        let button = UIButton(title: "Close")
        return button
    }()

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        return aiv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.edgesToSuperview()
        setupBinding()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()

    }

    private func setupBinding() {
        
        viewModel.loading.bind(to: activityIndicatorView.rx.isAnimating)
        .disposed(by: disposeBag)
        
        viewModel.loadPageTrigger.onNext(())
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<PresentationSection>(configureCell: { [weak self]
            (ds, cv, ip, item) in
            guard let self = self else { fatalError() }
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: self.cellId, for: ip) as? SearchCell else { return UICollectionViewCell() }
            cell.news = item
            return cell
        })
        
        viewModel.news
            .observeOn(MainScheduler.instance)
            .map({
                items in [PresentationSection(header: "", items: items)]
            })
            .bind(to: collectionView.rx.items(dataSource: dataSource))
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
   
}

