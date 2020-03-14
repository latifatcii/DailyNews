//
//  NewsViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/13/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

private let featuredCellId = "featuredCellId"
private let healthCellId = "healthCellId"
private let sportsCellId = "sportsCellId"
private let businessCellId = "businessCellId"
private let technologyCellId = "technologyCellId"
private let scienceCellId = "scienceCellId"
private let entertainmentCellId = "entertainmentCellId"

private let menuCells = [FeaturedCell.self,HealthCell.self,SportsCell.self,BusinessCell.self,TechnologyCell.self,ScienceCell.self,EntertainmentCell.self]

class NewsBaseController: BaseListController , UICollectionViewDelegateFlowLayout{
    
    var menuView = MenuViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenuView()
        configureCollectionView()
        
    }
    
    fileprivate func configureCollectionView() {
        registerCells()
        
        collectionView.isPagingEnabled = true
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 44).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    fileprivate func registerCells() {
        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: featuredCellId)
        collectionView.register(HealthCell.self, forCellWithReuseIdentifier: healthCellId)
        collectionView.register(SportsCell.self, forCellWithReuseIdentifier: sportsCellId)
        collectionView.register(BusinessCell.self, forCellWithReuseIdentifier: businessCellId)
        collectionView.register(TechnologyCell.self, forCellWithReuseIdentifier: technologyCellId)
        collectionView.register(ScienceCell.self, forCellWithReuseIdentifier: scienceCellId)
        collectionView.register(EntertainmentCell.self, forCellWithReuseIdentifier: entertainmentCellId)
        
    }
    
    func configureMenuView() {
        view.addSubview(menuView.view)
        
        menuView.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.view.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuCells.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell
        
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: featuredCellId, for: indexPath) as! FeaturedCell
        
        }
        else if indexPath.item == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: businessCellId, for: indexPath) as! BusinessCell
        }
        else if indexPath.item == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsCellId, for: indexPath) as! SportsCell
            
        }
        else if indexPath.item == 3 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: technologyCellId, for: indexPath) as! TechnologyCell
            
        }
        else if indexPath.item == 4 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: scienceCellId, for: indexPath) as! ScienceCell
            
        }
        else if indexPath.item == 5 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: entertainmentCellId, for: indexPath) as! EntertainmentCell
            
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: healthCellId, for: indexPath) as! HealthCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}
