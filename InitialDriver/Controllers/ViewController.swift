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
    
    let url = URL(string: "mapbox://styles/mapbox/streets-v10")
    let currentPosition = LocationServices.shared.position.asObservable()
    let addressPosition = LocationServices.shared.address.asObservable()
    let disposeBag = DisposeBag()
    var mapView: MGLMapView!
    var pinPosition = MGLPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        configPositionForMapview()

        pinPosition.title = ""
        pinPosition.subtitle = ""
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.addAnnotation(pinPosition)
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
                            self.pinPosition.coordinate = self.mapView.centerCoordinate
                            self.mapView.setCenter(value.coordinate, zoomLevel: 10.0, animated: true)
                            self.mapView.delegate = self
                        }
                        LocationServices.shared.isUserLocated = false
                    } else {
                        DispatchQueue.main.async {
                            self.pinPosition.coordinate = self.mapView.centerCoordinate
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

extension ViewController: MGLMapViewDelegate {

    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }

    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        DispatchQueue.main.async {
            self.pinPosition.coordinate = mapView.centerCoordinate
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        print("REGION DID CHANGED")
        LocationServices.shared.position.value = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
}
