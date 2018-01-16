//
//  ViewController.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 08/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import UIKit
import Mapbox
import RxCocoa
import RxSwift
import SideMenu
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var menuBT: UIButton!
    @IBOutlet weak var autoCompletionTV: AutoCompletionTableView!
    let currentPosition = LocationServices.shared.position.asObservable()
    let addressPosition = LocationServices.shared.address.asObservable()
    let disposeBag = DisposeBag()
    var mapView: MapView!
    
    // MARK: LiveCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapViewBox(frame: view.bounds)
        view.insertSubview(mapView, at: 0)
        configPositionForMapview()
        configTextField()
        mapView.delegate = self
        autoCompletionTV.isHidden = true
        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: MenuViewController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: RxSwift Config Data
    func configTextField() {
        addressTF.clearButtonMode = .whileEditing
        addressTF.rx
            .controlEvent(.editingDidBegin)
            .asObservable()
            .bind { _ in
                LocationServices.shared.cancelGeoCode()
                self.showAutocompletionTableview(true)
            }.disposed(by: disposeBag)

        addressTF.rx
            .controlEvent(.editingChanged)
            .asObservable()
            .bind { _ in
                guard let address = self.addressTF.text else {
                    print("addressTF.text == nil")
                    return
                }
                self.showAutocompletionTableview(true)
                self.autoCompletionTV.geoCodingAdress(address: address)
            }.disposed(by: disposeBag)
        
        addressTF.rx
            .controlEvent(.editingDidEnd)
            .asObservable()
            .bind { _ in
                self.showAutocompletionTableview(false)
        }.disposed(by: disposeBag)

        addressTF.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .bind { _ in
                self.view.endEditing(true)
            }.disposed(by: disposeBag)

    }
    
    func configPositionForMapview() {
        currentPosition.subscribe { (event) in
            switch event {
            case .next(let value):
                print("lat : \(value.coordinate.latitude) lon : \(value.coordinate.latitude)")
                if (LocationServices.shared.centerMap == true) {
                    LocationServices.shared.centerMap = false
                    if (self.mapView.centerCoordinate.latitude != value.coordinate.latitude
                        || self.mapView.centerCoordinate.longitude != value.coordinate.longitude) {
                    DispatchQueue.main.async {
                            self.mapView.setCenter(coordinate: value.coordinate, animated: false)
                        }
                    }
                } else {
                    LocationServices.shared.getAdress(position: value)
                }
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
            
            }.disposed(by: disposeBag)
        
        addressPosition.bind { (address) in
                DispatchQueue.main.async {
                    self.addressTF.text = address
                }
            }.disposed(by: disposeBag)
        
    }

    
    func showAutocompletionTableview(_ show: Bool) {
        DispatchQueue.main.async {
            if (show && self.autoCompletionTV.isHidden) {
                self.autoCompletionTV.isHidden = false
                self.mapView.isHidden = true
                UIView.transition(with: self.menuBT, duration: 0.5, options: .transitionFlipFromRight, animations: {
                    self.menuBT.setImage(#imageLiteral(resourceName: "back"), for: .normal)
                }, completion: nil)
            } else if (show == false)   {
                self.autoCompletionTV.isHidden = true
                self.mapView.isHidden = false
                self.view.endEditing(true)
                UIView.transition(with: self.menuBT, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    self.menuBT.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
                }, completion: nil)
            }
        }
    }

    // MARK: Actions
    @IBAction func presentMenu(_ sender: Any) {
        if (autoCompletionTV.isHidden == false) {
            showAutocompletionTableview(false)
        } else {
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        
    }
}

// MARK: MapViewDelegate
extension ViewController: MapViewDelegate {
    func didChangedRegion(location: CLLocation) {
        let new = mapView.centerCoordinate
        let old = LocationServices.shared.position.value.coordinate
        
        let n_lat = String(format: "%0.6f", new.latitude)
        let n_lon = String(format: "%0.6f", new.longitude)
        let o_lat = String(format: "%0.6f", old.latitude)
        let o_lon = String(format: "%0.6f", old.longitude)
        if ((LocationServices.shared.centerMap == false)
             && (n_lat != o_lat)
             || (n_lon != o_lon)) {
//            print("new lat : \(n_lat) lon : \(n_lon)")
//            print("old lat : \(o_lat) lon : \(o_lon)")

            LocationServices.shared.position.value = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        }
    }
    
    func isChangingRegion(location: CLLocation) {
        LocationServices.shared.cancelGeoCode()
        self.view.endEditing(true)
    }
}
