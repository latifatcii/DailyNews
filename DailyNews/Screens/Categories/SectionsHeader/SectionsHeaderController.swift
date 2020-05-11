//
//  FeedHeaderCell.swift
//  DailyNews
//
//  Created by Latif Atci on 3/7/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
import RxSwift
import RxCocoa
import RxDataSources

class SectionsHeaderController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var category: THCategories!
    let disposeBag = DisposeBag()
    
    var viewModel: SectionsHeaderViewModel
    
    init(_ viewModel: SectionsHeaderViewModel = SectionsHeaderViewModel()) {
        self.viewModel = viewModel
//        viewModel.category = category
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupBinding()
    }
    
    func setupBinding() {
        viewModel.loadingTrigger.onNext(())
        
        viewModel.sectionHeaderNews
            .bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: SectionsHeaderCell.self)) { (index, news, cell) in
                cell.news = news
                cell.scrollIndicator.currentPage = index
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(TopHeadlinePresentation.self)
            .subscribe(onNext: { [weak self] news in
                let safariVC = SFSafariViewController(url: URL(string: news.url)!)
                self?.show(safariVC, sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(SectionsHeaderCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.dataSource = nil
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
