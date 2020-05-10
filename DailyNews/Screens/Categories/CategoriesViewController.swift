//
//  CategoriesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import TinyConstraints
import RxSwift
import RxCocoa
import RxDataSources

class CategoriesViewController: UIViewController {

    var collectionView: UICollectionView!
    let cellId = "cellId"
    let categoryImageNames = ["featured", "business", "sports", "technology", "science", "entertainment", "health"]
    let categoryNames = ["Featured", "Business", "Sports", "Technology", "Science", "Entertainment", "Health"]
     let listOfCategories = [FeaturedCategoryController(), BusinessCategoryController(), SportsCategoryController(), TechnologyCategoryController(), ScienceCategoryController(), EntertainmentCategoryController(), HealthCategoryController()]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupBinding()
    }
    
    func setupBinding() {

        let items = Observable.just (
            self.categoryNames.map { $0 }
        )

        items.bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: CategoriesCell.self)) { [weak self]
            (item, data, cell) in
            guard let self = self else { return }
            cell.categoryLabel.text = data
            cell.categoryImageView.image = UIImage(named: self.categoryImageNames[item])
        }
        .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self]
                index in
                guard let self = self else { return }
                self.listOfCategories[index.item].title = self.categoryNames[index.item]
                self.navigationController?.pushViewController(self.listOfCategories[index.item], animated: true)

            })
        .disposed(by: disposeBag)

    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                    collectionViewLayout: UIHelper.createTwoColumnFlowLayoutForCategories(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CategoriesCell
//            else { return UICollectionViewCell() }
//        cell.categoryImageView.image = UIImage(named: categoryImageNames[indexPath.item])
//        cell.categoryLabel.text = categoryNames[indexPath.item]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        listOfCategories[indexPath.item].title = categoryNames[indexPath.item]
//        self.navigationController?.pushViewController(listOfCategories[indexPath.item], animated: true)
//    }
}
