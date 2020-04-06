//
//  CategoriesViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 4/4/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class CategoriesViewController : UIViewController {
    
    var collectionView : UICollectionView!
    let cellId = "cellId"
    let listOfCategories = [FeaturedCategoryController(),BusinessCategoryController(),SportsCategoryController(),TechnologyCategoryController(),ScienceCategoryController(),EntertainmentCategoryController(),HealthCategoryController()]
    
    let categoryImageNames = ["featured","business","sports","technology","science","entertainment","health"]
    
    let categoryNames = ["Featured","Business","Sports","Technology","Science","Entertainment","Health"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
}

extension CategoriesViewController : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoriesCell
        cell.categoryImageView.image = UIImage(named: categoryImageNames[indexPath.item])
        cell.categoryLabel.text = categoryNames[indexPath.item]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listOfCategories[indexPath.item].title = categoryNames[indexPath.item]
        self.navigationController?.pushViewController(listOfCategories[indexPath.item], animated: true)
        
    }
    
    
    
}

