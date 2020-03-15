//
//  PagingController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/15/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import Parchment

class PagingController : UIViewController , PagingViewControllerDataSource  {
    
    
    
    private let cities: [PagingItem] = [
        PagingIndexItem(index: 0, title: "Featured"),
        PagingIndexItem(index: 1, title: "Business"),
        PagingIndexItem(index: 2, title: "Sports"),
        PagingIndexItem(index: 3, title: "Technology"),
        PagingIndexItem(index: 4, title: "Science"),
        PagingIndexItem(index: 5, title: "Entertainment"),
        PagingIndexItem(index: 6, title: "Health")
        
    ]
    
    private let sections = [FeaturedSectionController(),BusinessSectionController(),SportsSectionController(),TechnologySectionController(),ScienceSectionController(),EntertainmentSectionController(),HealthSectionController()]
    
    private let pagingViewController = PagingViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePagingViewController()
        
    }
    
    
    fileprivate func configurePagingViewController() {
        pagingViewController.dataSource = self
        pagingViewController.menuItemSize = .fixed(width: view.frame.width/4, height: 44)
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            
        ])
    }
    
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return cities.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        
        return sections[index]
        
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return cities[index]
    }
    
    
    
    

    

}
