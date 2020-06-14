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

class SideMenuNewsViewController: UIViewController {

    var sourceName: String!
    var sourceId: String!
    var collectionView: UICollectionView!
    let cellId = "cellId"
    let viewModel: SideMenuNewsViewModel
    
    init(_ viewModel: SideMenuNewsViewModel = SideMenuNewsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
   
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
   }

   private func configureCollectionView() {
       collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
       collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
       collectionView.backgroundColor = .systemBackground
       view.addSubview(collectionView)
       collectionView.edgesToSuperview()

   }
}

