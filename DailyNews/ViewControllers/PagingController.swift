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
    let menu = UIViewController()
    
    private var isMenuHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePagingViewController()
        configureSlideMenu()
        
        
    }
    
    func configureSlideMenu() {
        let menuButton = UIBarButtonItem(title: "Menu", style: .done, target: self, action: #selector(openMenu))
        
        self.navigationItem.leftBarButtonItem = menuButton
        addChild(menu)
        
        view.insertSubview(menu.view, at: 0)
        menu.didMove(toParent: self)
        menu.view.backgroundColor = .orange
        //        menu.view.isHidden = true
        menu.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: 200, height: 0))
        //        menu.view.frame = view.frame
        
        let label = UILabel(text: "HakkarimNette  BatakKeyfi", font: .boldSystemFont(ofSize: 24))
        label.numberOfLines = 0
        menu.view.addSubview(label)
        label.anchor(top: menu.view.topAnchor, leading: menu.view.leadingAnchor, bottom: menu.view.bottomAnchor, trailing: menu.view.trailingAnchor)
        
        
    }
    
    @objc func openMenu() {
        
        if !isMenuHidden {
            pagingViewController.view.frame.origin.x = 0
            
            menu.view.isHidden = true
            isMenuHidden = true
            
        }
        else {
            pagingViewController.view.frame.origin.x = pagingViewController.view.frame.width - 220
            isMenuHidden = false
            menu.view.isHidden = false
            
        }
        
        
        
    }
    
    fileprivate func configurePagingViewController() {
        pagingViewController.dataSource = self
        pagingViewController.menuItemSize = .fixed(width: view.frame.width/4, height: 44)
        pagingViewController.menuBackgroundColor = .systemGray3
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            
            
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
