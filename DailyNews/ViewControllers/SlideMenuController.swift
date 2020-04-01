//
//  SwipeMenuController.swift
//  DailyNews
//
//  Created by Latif Atci on 3/31/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import UIKit

class SlideMenuController : UIViewController , UITableViewDataSource {
    
    var tableView : UITableView!
    let slideMenuCellId = "CellId"
    var sourcesGeneral : [Sources] = []
    var sourcesBusiness : [Sources] = []
    var sourcesEntertainment : [Sources] = []
    var sourcesHealth : [Sources] = []
    var sourcesScience : [Sources] = []
    var sourcesSports : [Sources] = []
    var sourcesTechnology : [Sources] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        tableView.dataSource = self
        fetchSources()
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        aiv.color = .black
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SlideMenuCell.self, forCellReuseIdentifier: slideMenuCellId)
        view.addSubview(tableView)
        
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesSports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: slideMenuCellId, for: indexPath) as! SlideMenuCell
        cell.menuLabel.text = sourcesSports[indexPath.item].name
        cell.selectionStyle = .none
        return cell
    }
    
    func fetchSources() {
        let dispatchGroup = DispatchGroup()
        
        var generalGroup : [Sources] = []
        var businessGroup : [Sources] = []
        var entertainmentGroup : [Sources] = []
        var healthGroup : [Sources] = []
        var scienceGroup : [Sources] = []
        var sportsGroup : [Sources] = []
        activityIndicatorView.startAnimating()

        
        dispatchGroup.enter()
        FetchNews.shared.fetchSources(SRequest(category: .general, language: "en", country: nil)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let sourcesResponse):
                generalGroup.append(contentsOf: sourcesResponse.sources)
            case .failure(let err):
                print(err)
            }
            
        }
        dispatchGroup.enter()
        FetchNews.shared.fetchSources(SRequest(category: .business, language: "en", country: nil)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let sourcesResponse):
                businessGroup.append(contentsOf: sourcesResponse.sources)
            case .failure(let err):
                print(err)
            }
            
        }
        dispatchGroup.enter()
        FetchNews.shared.fetchSources(SRequest(category: .entertainment, language: "en", country: nil)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let sourcesResponse):
                entertainmentGroup.append(contentsOf: sourcesResponse.sources)
            case .failure(let err):
                print(err)
            }
            
        }
        dispatchGroup.enter()
        FetchNews.shared.fetchSources(SRequest(category: .health, language: "en", country: nil)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let sourcesResponse):
                healthGroup.append(contentsOf: sourcesResponse.sources)
            case .failure(let err):
                print(err)
            }
            
        }
        dispatchGroup.enter()
        FetchNews.shared.fetchSources(SRequest(category: .science, language: "en", country: nil)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let sourcesResponse):
                scienceGroup.append(contentsOf: sourcesResponse.sources)
            case .failure(let err):
                print(err)
            }
            
        }
        dispatchGroup.enter()
        FetchNews.shared.fetchSources(SRequest(category: .sports, language: "en", country: nil)) { (result) in
            dispatchGroup.leave()
            switch result {
            case .success(let sourcesResponse):
                sportsGroup.append(contentsOf: sourcesResponse.sources)
            case .failure(let err):
                print(err)
            }
            
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()

            self.sourcesGeneral.append(contentsOf: generalGroup)
            self.sourcesBusiness.append(contentsOf: businessGroup)
            self.sourcesEntertainment.append(contentsOf: entertainmentGroup)
            self.sourcesHealth.append(contentsOf: healthGroup)
            self.sourcesSports.append(contentsOf: sportsGroup)
            self.sourcesScience.append(contentsOf: scienceGroup)
            self.tableView.reloadData()
        }
        
        
    }
    
}
