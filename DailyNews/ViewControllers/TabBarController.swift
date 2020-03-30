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
    
    let viewcont = UIViewController()
    
    private var isMenuHidden = true
    
    func configureTabBar() {
        let feedVC = PagingController()
        feedVC.title = "News"
        feedVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "house"), tag: 0)
        
        
        let sourcesVC = SearchNewsController()
        sourcesVC.title = "Search"
        sourcesVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let feedNavigationController = UINavigationController(rootViewController: feedVC)
        
        let sourcesNavigationController = UINavigationController(rootViewController: sourcesVC)
        
        sourcesNavigationController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [feedNavigationController , sourcesNavigationController]
        

        addChild(viewcont)
        
        view.insertSubview(viewcont.view, at: 0)
        
        viewcont.didMove(toParent: self)
        viewcont.view.backgroundColor = .black
        viewcont.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: 200, height: 0))
        
        let menuButton = UIBarButtonItem(title: "Menu", style: .done, target: self, action: #selector(openMenu))
        
        feedVC.navigationItem.leftBarButtonItem = menuButton
        
    }
    @objc func openMenu() {
        
        if !isMenuHidden {
            view.frame.origin.x = 0
            
            viewcont.view.isHidden = true
            isMenuHidden = true
            
        }
        else {
            view.frame.origin.x = view.frame.width - 220
            isMenuHidden = false
            viewcont.view.isHidden = false
            
        }
        
        
        
    }
    
    
}

