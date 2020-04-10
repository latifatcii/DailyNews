//
//  Protocols.swift
//  DailyNews
//
//  Created by Latif Atci on 3/31/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate: class {
    func configureSlideMenu()
}
protocol SlideMenuGestureDelegate: class {
    func configureTapGestureForSlideMenu()
}
protocol SlideMenuTableViewDelegate: class {
    func didSelectSlideMenuCell(cell: UITableViewCell)
}
protocol SourcesViewControllerDelegate: class {
    func pushToSourcesVC(source: UIViewController)
}
