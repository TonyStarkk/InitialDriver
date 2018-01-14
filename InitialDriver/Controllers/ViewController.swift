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

class ViewController: UIViewController {
    
    @IBOutlet weak var addressTF: UITextField!
    
    let currentPosition = LocationServices.shared.position.asObservable()
    let addressPosition = LocationServices.shared.address.asObservable()
    let disposeBag = DisposeBag()
    var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MapViewBox(frame: view.bounds)
        view.insertSubview(mapView, at: 0)
        configPositionForMapview()
        mapView.delegate = nil
        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: MenuViewController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationServices.shared.start()
    }
    
    func configPositionForMapview() {
        currentPosition.subscribe { (event) in
            switch event {
                case .next(let value):
                    if (LocationServices.shared.isUserLocated) {
                        DispatchQueue.main.async {
                            self.mapView.setCenter(coordinate: value.coordinate)
                            self.mapView.delegate = self
                        }
                        LocationServices.shared.isUserLocated = false
                    } else {
                        DispatchQueue.main.async {
                            self.mapView.delegate = self
                        }
                    }
                    LocationServices.shared.getAdress()
                case .error(let error):
                    print(error)
                case .completed:
                    print("completed")
            }

        }.disposed(by: disposeBag)

        addressPosition.bind { (address) in
            print("CURRENT ADDRESS -> \(address)")
            DispatchQueue.main.async {
                self.addressTF.text = address
            }
        }.disposed(by: disposeBag)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Actions
    
    @IBAction func presentMenu(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        
    }
}

extension ViewController: MapViewDelegate {
    
    func didChangedRegion(location: CLLocation) {
        LocationServices.shared.position.value = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    func isChangingRegion(location: CLLocation) {
        self.view.endEditing(true)
    }
    
}
