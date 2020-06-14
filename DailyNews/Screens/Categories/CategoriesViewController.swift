//
//  CategoriesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import TinyConstraints

class CategoriesViewController: UIViewController {

    var collectionView: UICollectionView!
    let cellId = "cellId"
    let categoryImageNames = ["featured", "business", "sports", "technology", "science", "entertainment", "health"]
    let categoryNames = ["Featured", "Business", "Sports", "Technology", "Science", "Entertainment", "Health"]
     let listOfCategories = [FeaturedCategoryController(), BusinessCategoryController(), SportsCategoryController(), TechnologyCategoryController(), ScienceCategoryController(), EntertainmentCategoryController(), HealthCategoryController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                    collectionViewLayout: UIHelper.createTwoColumnFlowLayoutForCategories(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
}
