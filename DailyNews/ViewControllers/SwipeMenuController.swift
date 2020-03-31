//
//  SwipeMenuController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/31/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class SwipeMenuController : UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureView()
    }
    
    private func configureView() {
        let label = UILabel(text: "merabaasdasdasdasdasdasdasda", font: .italicSystemFont(ofSize: 50))
        view.addSubview(label)
        label.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        label.numberOfLines = 0
        
    }
    
}
