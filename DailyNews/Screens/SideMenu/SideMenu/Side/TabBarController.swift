//
//  ViewController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/3/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var feedVC = NewsViewController()
    let searchVC = SearchNewsController()
    let categoriesVC = CategoriesViewController()
    weak var menuDelegate: SlideMenuDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTabBar()
        setupMenuButton()

    }

    func configureTabBar() {
        feedVC.title = "News"
        feedVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "house"), tag: 0)
        categoriesVC.title = "Categories"
        categoriesVC.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "paperplane"), tag: 1)
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)

        let feedNavigationController = UINavigationController(rootViewController: feedVC)
        let categoriesNavigationController = UINavigationController(rootViewController: categoriesVC)
        let searchNavigationController = UINavigationController(rootViewController: searchVC)
        searchNavigationController.navigationBar.prefersLargeTitles = true
        viewControllers = [feedNavigationController, categoriesNavigationController, searchNavigationController]

    }

    private func setupMenuButton() {
        let menuButton = UIBarButtonItem(image: UIImage(named: "hamburger.png"),
                                         style: .plain, target: self, action: #selector(openMenu))
        feedVC.navigationItem.leftBarButtonItem = menuButton
        feedVC.navigationItem.leftBarButtonItem?.tintColor = .black
    }

    @objc func openMenu() {
        menuDelegate?.configureSlideMenu()
    }


}
