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
        let feedVC = PagingController()
        feedVC.title = "News"
        feedVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "house"), tag: 0)

        
        let sourcesVC = SearchNewsController()
        sourcesVC.title = "Sources"
        sourcesVC.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "star"), tag: 1)
        
        let feedNavigationController = UINavigationController(rootViewController: feedVC)
        let sourcesNavigationController = UINavigationController(rootViewController: sourcesVC)
        
        sourcesNavigationController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [feedNavigationController , sourcesNavigationController]
        
    }


}

