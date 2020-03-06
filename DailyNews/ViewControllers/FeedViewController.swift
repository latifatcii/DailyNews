//
//  FeedViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class FeedViewController : UIViewController , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {

    let layout = UICollectionViewFlowLayout()
    var collectionView : UICollectionView!
    let feedCellId = "feedCellId"
    let newsCellId = "newsCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
    }
    
    
    func configureCollectionView() {

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: feedCellId)
        collectionView.register(NewsCell2.self, forCellWithReuseIdentifier: newsCellId)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        view.addSubview(collectionView)

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : FeedCell
        
        if indexPath.item == 0 {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! FeedCell
        }
        else {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as! NewsCell2
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        if indexPath.item == 0 {
            return .init(width: view.frame.width, height: view.frame.width/1.8) }


        return .init(width: view.frame.width, height: view.frame.width / 1.2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
