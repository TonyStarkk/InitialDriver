//
//  LocationServices.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 09/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import MapKit
import CoreLocation
import RxSwift
import SwiftyUserDefaults

typealias JSONDictionary = [String:Any]

public class LocationServices: NSObject  {
    
    static let shared = LocationServices()
    var locManager = CLLocationManager()
    var position: Variable<CLLocation> = Variable(CLLocation())
    var address: Variable<String> = Variable(String())
    var arrPosition: Variable<[Address]> = Variable([])
    var isUserLocated = false
    var isAuthorized = false
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    private override init() {}
    
    func start() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locManager.requestWhenInUseAuthorization()
        } else {
            locManager.startUpdatingLocation()
        }
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }

    }
    
    private func addPosition(address: String) {
        
        let results = arrPosition.value.filter { $0.address == address }
        if (results.isEmpty == true) {
            let pos = Address(position: self.position.value, address: address)

            if (arrPosition.value.count == 15) {
                arrPosition.value.removeLast()
            }
            arrPosition.value.insert(pos, at: 0)
        }
    }
    
    public func getAdress() {
        if self.authStatus == inUse || self.authStatus == always {
            let geoCoder = CLGeocoder()
            self.address.value = "Loading.."
            geoCoder.reverseGeocodeLocation(position.value) { placemarks, error in
                if let e = error {
                    print(e)
                } else {
                    let placeArray = placemarks
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    guard let addressDictionnary = placeMark.addressDictionary as? JSONDictionary,
                        let street = addressDictionnary["Street"] as? String,
                        let city = addressDictionnary["City"] as? String,
                        let postalCode = placeMark.postalCode
                       else {
                        self.address.value = "Unamed Road"
                        return
                    }
                    let address = "\(street) \(postalCode) \(city)"
                    self.addPosition(address: address)
                    self.address.value = address

                }
            }
        }
    }
}

extension LocationServices: CLLocationManagerDelegate {
    //this method will be called each time when a user change his location access preference.
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("User allowed us to access location")
            locManager.startUpdatingLocation()
            break;
        case .notDetermined:
            print("Not determined")
        default:
            print("User not allowed")
            // position default to activate delegate method on mapView
            isAuthorized = false
            position.value = CLLocation()
            break;
        }
        if status == .authorizedWhenInUse {

            //do whatever init activities here.
        }
    }
    
    //this method is called by the framework on locationManager.requestLocation();
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did location updates is called")
        guard let location = locations.last else {
            print("error on Updated location")
            return
        }
        print("\(location)")
        if (LocationServices.shared.position.value != location && CLLocationCoordinate2DIsValid(location.coordinate) == true) {
            print("did update location !!!")
            isUserLocated = true
            LocationServices.shared.position.value = location
            manager.stopUpdatingLocation()
            manager.delegate = nil
        } else {
            print("bad coordinate")
        }

    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
}

