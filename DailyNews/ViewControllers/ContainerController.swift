//
//  ContainerController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/31/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class ContainerController : UIViewController {
    
    let tabBar = TabBarController()
    var menuController : SlideMenuController!
    private var isMenuHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBarView()
        tabBar.menuDelegate = self
        tabBar.menuSlideDelegate = self
        
        
    }
    
    func setupTabBarView() {
        view.addSubview(tabBar.view)
        addChild(tabBar)
        tabBar.didMove(toParent: self)
    }
    
    
    func setupMenuController() {
        
        if menuController == nil {
            menuController = SlideMenuController()
            menuController.sourceDelegate = self
            addChild(menuController)
            view.insertSubview(menuController.view, at: 0)
            menuController.didMove(toParent: self)
            
            menuController.view.backgroundColor = .systemBackground
            menuController.didMove(toParent: self)
            
            menuController.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: 250, height: 0))
        }
    }
    
    func showMenuController(shouldExpand : Bool) {
        if !shouldExpand {
            
            
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.tabBar.view.frame.origin.x = self.tabBar.view.frame.width - 165
            }) { (_) in
                self.tabBar.feedVC.view.isUserInteractionEnabled = false

            }
        }
        else  {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.tabBar.view.frame.origin.x = 0
                
            }) { (_) in
                self.isMenuHidden = true
                self.tabBar.feedVC.view.isUserInteractionEnabled = true
//                self.pushToSourcesVC()
            }
        }
    }
    
    
}
extension ContainerController : SlideMenuDelegate , SourcesViewControllerDelegate {
    func pushToSourcesVC() {
        
        print("bas")
    }
    
    func configureSlideMenu() {
        
        if isMenuHidden {
            setupMenuController()
        }
        
        isMenuHidden = !isMenuHidden
        showMenuController(shouldExpand: isMenuHidden)
    }
    
    
}

extension ContainerController : SlideMenuGestureDelegate {
    func configureTapGestureForSlideMenu() {
        

        showMenuController(shouldExpand: true)

        
    }
    
    
}
