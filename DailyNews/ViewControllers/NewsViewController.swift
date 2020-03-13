//
//  NewsViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/13/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewsViewController: BaseListController , UICollectionViewDelegateFlowLayout{
    
    var menuView = MenuViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenuView()
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "aaa")
    
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 44).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
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
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aaa", for: indexPath) as! NewsCell
        if indexPath.item % 2 == 0 {
            cell.feed.view.backgroundColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }

}
