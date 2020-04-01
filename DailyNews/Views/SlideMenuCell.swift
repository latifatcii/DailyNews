//
//  SlideMenuCell.swift
//  DailyNews
//
//  Created by Latif Atci on 4/1/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class SlideMenuCell : UITableViewCell {
    
    var menuLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(menuLabel)
        menuLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        menuLabel.text = "Menasdadasdasdadasdad"
    }
    
}
