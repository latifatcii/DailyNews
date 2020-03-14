//
//  ViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureTabBar()
    }
    
    func configureTabBar() {
        let feedVC = NewsBaseController()
        feedVC.title = "News"
        feedVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        
        let sourcesVC = SourcesViewController()
        sourcesVC.title = "Sources"
        sourcesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let feedNavigationController = UINavigationController(rootViewController: feedVC)
        let sourcesNavigationController = UINavigationController(rootViewController: sourcesVC)
        
//        feedNavigationController.navigationBar.prefersLargeTitles = true
        sourcesNavigationController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [feedNavigationController , sourcesNavigationController]
        
    }


}

