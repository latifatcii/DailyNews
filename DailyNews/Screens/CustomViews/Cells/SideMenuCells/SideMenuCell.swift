//
//  SideMenuCell.swift
//  DailyNews
//
//  Created by Latif Atci on 4/1/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    weak var slideDelegate: SlideMenuTableViewDelegate?
    var menuLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 12)
        return label
    }()
    var sources: Sources? {
        didSet {
            if let sources = sources {
            textLabel?.text = sources.name
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let arrowButton = UIButton(frame: .init(x: 0, y: 0, width: 50, height: 50))
        arrowButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        arrowButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        accessoryView = arrowButton
    }

    @objc func addFavorite(button: UIButton) {
        slideDelegate?.didSelectSlideMenuCell(cell: self)
    }
}
