//
//  ViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let feedVC = PagingController()
    let searchVC = SearchNewsController()
    var menuDelegate : SlideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTabBar()
        setupMenuButton()


    }
    
    func configureTabBar() {
        feedVC.title = "News"
        feedVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "house"), tag: 0)
        
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let feedNavigationController = UINavigationController(rootViewController: feedVC)
        
        let sourcesNavigationController = UINavigationController(rootViewController: searchVC)
        
        sourcesNavigationController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [feedNavigationController , sourcesNavigationController]
        
    }
    
    private func setupMenuButton() {
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "hamburger.png"), style: .plain, target: self, action: #selector(openMenu))
        
        feedVC.navigationItem.leftBarButtonItem = menuButton
        feedVC.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    
    @objc func openMenu() {
        menuDelegate?.configureSlideMenu()

    }

  
}

