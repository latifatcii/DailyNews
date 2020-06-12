//
//  SectionsHeaderController.swift
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
    let disposeBag = DisposeBag()
    
    var viewModel: SectionsHeaderViewModel
    
    init(_ viewModel: SectionsHeaderViewModel) {
        self.viewModel = viewModel
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
        viewModel.loadPageTrigger.onNext(())
        
            let dataSource = RxCollectionViewSectionedReloadDataSource<TopHeadlinePresentationSection>(configureCell: {
                (ds, cv, ip, news) in
                guard let cell = cv.dequeueReusableCell(withReuseIdentifier: self.cellId, for: ip) as? SectionsHeaderCell else { return UICollectionViewCell() }
                cell.news = news
                cell.scrollIndicator.currentPage = ip.item
                return cell
                })
            
        viewModel.sectionHeaderNews
                .observeOn(MainScheduler.instance)
                .map {
                    news in [TopHeadlinePresentationSection(items: news)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
            
            collectionView.rx.modelSelected(TopHeadlinePresentation.self)
                .subscribe(onNext: { [weak self]
                    news in
                    guard let self = self else { return }
                    let safariVC = SFSafariViewController(url: URL(string: news.url)!)
                    self.show(safariVC, sender: nil)
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
