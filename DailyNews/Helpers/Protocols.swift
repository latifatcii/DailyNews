//
//  Protocols.swift
//  DailyNews
//
//  Created by Latif Atci on 3/31/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func configureSlideMenu()
}
protocol SlideMenuGestureDelegate {
    func configureTapGestureForSlideMenu()
}

protocol SlideMenuTableViewDelegate{
    func didSelectSlideMenuCell(cell : UITableViewCell)
}

protocol SourcesViewControllerDelegate {
    func pushToSourcesVC(source : UIViewController)
}
