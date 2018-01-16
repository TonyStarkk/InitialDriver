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
    var position: Variable<CLLocation> = Variable(CLLocation())
    var address: Variable<String> = Variable(String())
    var arrPosition: Variable<[Address]> = Variable([])
    var centerMap = false
    let geoCoder = CLGeocoder()
    
    // singleton pattern
    private override init() {}
    
    public func addPosition(address: String) {
        
        let results = arrPosition.value.filter { $0.address == address }
        if (results.isEmpty == true) {
            let pos = Address(position: self.position.value, address: address)

            if (arrPosition.value.count == 15) {
                arrPosition.value.removeLast()
            }
            arrPosition.value.insert(pos, at: 0)
        }
    }
    
    public func getAdress(position: CLLocation) {

        self.address.value = "Loading..."
        geoCoder.reverseGeocodeLocation(position) { placemarks, error in
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
                    self.address.value = ""
                    return
                }
                
                let address = "\(street) \(postalCode) \(city)"
                self.addPosition(address: address)
                self.address.value = address
                if (position.coordinate.longitude != self.position.value.coordinate.longitude
                    || position.coordinate.latitude != self.position.value.coordinate.latitude) {
                    self.position.value = position
                }
            }
        }
    }
    
    func    cancelGeoCode() {
        if (geoCoder.isGeocoding == true) {
            self.address.value = ""
            geoCoder.cancelGeocode()
        }
    }
}

