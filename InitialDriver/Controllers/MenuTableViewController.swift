//
//  MenuTableViewController.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 11/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UITableViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.delegate = nil
        navigationController?.navigationBar.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        LocationServices.shared.arrPosition.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = element.address
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Address.self)
            .subscribe(onNext:  { value in
                self.dismiss(animated: true, completion: {
                    LocationServices.shared.centerMap = true
                    LocationServices.shared.position.value = value.position
                })
            })
            .disposed(by: disposeBag)
            }
}
