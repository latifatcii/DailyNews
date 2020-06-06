//
//  ExpandableCellDataSource.swift
//  DailyNews
//
//  Created by Latif Atci on 5/18/20.
//  Copyright © 2020 Latif Atci. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

final class ExpandableCellDataSource<T, Cell: UITableViewCell>: NSObject, RxTableViewDataSourceType, UITableViewDataSource {
    
    private var rows = [T]()
    private var chosenRows = [Int]()
    private let loadCell: (T, Cell) -> Void
    private let expand: (T,Cell) -> Void
    private let contract: (T,Cell) -> Void
    private let disposeBag = DisposeBag()
    
    init(loadCell: @escaping (T, Cell) -> Void, expand: @escaping (T,Cell) -> Void, contract: @escaping (T,Cell) -> Void, tableView: UITableView) {
        self.loadCell = loadCell
        self.expand = expand
        self.contract = contract
        super.init()
        tableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let this = self else { return }
                print(indexPath.section)
                if this.chosenRows.contains(indexPath.row) {
                    self?.chosenRows.removeAll(where: { $0 == indexPath.row })
                }
                else {
                    self?.chosenRows.append(indexPath.row)
                }
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { return }
                let element = this.rows[indexPath.row]
                tableView.beginUpdates()
                this.adjustHeight(cell: cell, indexPath: indexPath, element: element)
                tableView.endUpdates()
            })
            .disposed(by: disposeBag)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! Cell
        let element = rows[indexPath.row]
        loadCell(element, cell)
        adjustHeight(cell: cell, indexPath: indexPath, element: element)
        return cell
    }
    func tableView(_ tableView: UITableView, observedEvent: Event<[T]>) {
        if case let .next(element) = observedEvent {
            rows = element
            tableView.reloadData()
        }
    }
    private func adjustHeight(cell: Cell, indexPath: IndexPath, element: T) {
        if chosenRows.contains(indexPath.row) {
            expand(element,cell)
        }
        else {
            contract(element,cell)
        }
    }

}
