//
//  CategoriesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class CategoriesViewController : UIViewController {
    
    var collectionView: UICollectionView!
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                    collectionViewLayout: UIHelper.createTwoColumnFlowLayoutForCategories(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor)
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CategoriesCell
            else {
                return UICollectionViewCell()
        }
        cell.categoryImageView.image = UIImage(named: Constants.categoryImageNames[indexPath.item])
        cell.categoryLabel.text = Constants.categoryNames[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Constants.listOfCategories[indexPath.item].title = Constants.categoryNames[indexPath.item]
        self.navigationController?.pushViewController(Constants.listOfCategories[indexPath.item], animated: true)
    }
}
