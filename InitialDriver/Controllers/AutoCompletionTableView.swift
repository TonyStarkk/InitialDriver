//
//  AutoCompletionTableView.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 13/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MapboxGeocoder

class AutoCompletionTableView: UITableView {
    
    var addresses: Variable<[Address]> = Variable([])
    let disposeBag = DisposeBag()
    let geocoder = Geocoder.shared
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initData()
    }
    
    private func initData() {
        self.delegate = nil
        self.dataSource = nil
        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableFooterView = UIView()
        bindData()
    }
    
    func geoCodingAdress(address: String) {
        let options = ForwardGeocodeOptions(query: address)
        
        // To refine the search, you can set various properties on the options object.
        options.focalLocation = LocationServices.shared.position.value
        options.allowedScopes = [.address, .pointOfInterest]
        
        let _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            self.addresses.value = []
            guard let placemarks = placemarks else {
                return
            }
            
            for (placemark) in placemarks {
                self.addresses.value.append(Address(position: placemark.location, address: placemark.qualifiedName))
            }

        }
    }
    
    private func bindData() {
        addresses.asObservable()
            .bind(to: self.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = element.address
            }
            .disposed(by: disposeBag)
        
        self.rx
            .modelSelected(Address.self)
            .subscribe(onNext:  { value in
                self.superview?.endEditing(true)
                LocationServices.shared.centerMap = true
                LocationServices.shared.address.value = value.address
                LocationServices.shared.position.value = value.position
            })
            .disposed(by: disposeBag)
    }
}
