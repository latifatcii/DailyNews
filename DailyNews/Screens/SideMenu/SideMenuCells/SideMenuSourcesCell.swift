//
//  SideMenuSourcesCell.swift
//  DailyNews
//
//  Created by Latif Atci on 5/19/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

final class SideMenuSourcesCell: UITableViewCell {
    
    var sourcesNames: Sources? {
        didSet {
            if let sourcesName = sourcesNames {
                textLabel?.text = sourcesName.name
                print(sourcesName.name)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
