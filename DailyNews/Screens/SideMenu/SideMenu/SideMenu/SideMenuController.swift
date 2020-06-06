//
//  SwipeMenuController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/31/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit
import SafariServices
import TinyConstraints
import RxSwift
import RxCocoa
import RxDataSources

class SideMenuController: UIViewController {
    
    var tableView: UITableView!
    let sideMenuCellId = "CellId"
    var sourceCategories = ["General", "Business", "Entertainment", "Health", "Sports", "Science"]
    weak var sourceDelegate: SourcesViewControllerDelegate?
    let activityIndicatorView = UIActivityIndicatorView(color: .black)
    let disposeBag = DisposeBag()
    let viewModel: SideMenuViewModel
    
    init(_ viewModel: SideMenuViewModel = SideMenuViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureTopView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.edgesToSuperview()
        setupBinding()
    }
    
    private func setupBinding() {
        viewModel.loading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.loadingTrigger.onNext(())

        let dataSource = ExpandableCellDataSource<ExpandedSources, SideMenuCell>(
        loadCell: { element, cell in
            cell.textLabel?.text = element.category.rawValue
            cell.sources = element.sources

        }, expand: { element, cell in
            cell.sources = element.sources
        }, contract: { element, cell in
            cell.sources?.removeAll()
        }, tableView: tableView
        )
        
//        let dataSource = RxTableViewSectionedReloadDataSource<ExpandedSourcesSectionModel>(configureCell: { ds, tv, ip, item in
//
//
//        }, titleForHeaderInSection: { a, b in
//
//        })
        
        
        viewModel.sources
            .observeOn(MainScheduler.instance)
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        
    }
    
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: sideMenuCellId)
        view.addSubview(tableView)
        tableView.edgesToSuperview(insets: .top(60), usingSafeArea: true)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 40
        tableView.separatorStyle = .none
    }
    
    private func configureTopView() {
        let slideMenuTopView = UIView(frame: .zero)
        view.addSubview(slideMenuTopView)
        slideMenuTopView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        slideMenuTopView.bottomToTop(of: tableView)
        let appIconImage = UIImageView(image: UIImage(named: "applogo"))
        slideMenuTopView.addSubview(appIconImage)
        appIconImage.edgesToSuperview(excluding: .trailing, usingSafeArea: true)
        appIconImage.width(60)
        appIconImage.layer.cornerRadius = 10
        
        let sourceNameLabel = UILabel(text: "Daily News", font: .boldSystemFont(ofSize: 22))
        sourceNameLabel.adjustsFontSizeToFitWidth = true
        slideMenuTopView.addSubview(sourceNameLabel)
        sourceNameLabel.centerInSuperview(offset: .init(x: 20, y: 0))
    }
}


extension SideMenuController: UITableViewDelegate {
    
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: sideMenuCellId, for: indexPath) as? SideMenuCell
//            else { return UITableViewCell() }
//        cell.arrowButton.rx.tap.subscribe(onNext: {
//            self.sourceDelegate?.pushToSourcesVC(source: SideMenuNewsViewController())
//        }).disposed(by: disposeBag)
//        //        cell.sources = self.sources[indexPath.section].sources[indexPath.row]
//        //
//        cell.selectionStyle = .none
//        return cell
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.tag = section
//        let label = UILabel(text: sourceCategories[section], font: .boldSystemFont(ofSize: 16))
//
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.addArrangedSubview(label)
//        stackView.addArrangedSubview(button)
//        stackView.distribution = .equalCentering
//        stackView.alignment = .center
//
//        headerView.addSubview(stackView)
//        stackView.edgesToSuperview(insets: .right(10))
//        return headerView
//    }
    
//    @objc func handleExpanding(button: UIButton) {
//        let section = button.tag
//        var indexPaths = [IndexPath]()
//        for row in sources[section].sources.indices {
//            let indexPath = IndexPath(row: row, section: section)
//            indexPaths.append(indexPath)
//        }
//        let isExpanded = sources[section].isExpanded
//        sources[section].isExpanded = !isExpanded
//        if isExpanded {
//            tableView.deleteRows(at: indexPaths, with: .fade)
//            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
//        } else {
//            tableView.insertRows(at: indexPaths, with: .fade)
//            button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
//        }
//    }
}
