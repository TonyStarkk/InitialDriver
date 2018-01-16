//
//  MapManager.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 08/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

@objc protocol MapViewDelegate {
    func didChangedRegion(location: CLLocation)
    func isChangingRegion(location: CLLocation)
    @objc optional func didFindUserLocation(location: CLLocationCoordinate2D)
}

class MapView: UIView {
    var delegate: MapViewDelegate?
    var isUserLocated = false
    
    private var _centerCoordinate = CLLocationCoordinate2D()
    var centerCoordinate: CLLocationCoordinate2D {
        get {
            return self._centerCoordinate
        }
        set {
            self._centerCoordinate = newValue
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCenter(coordinate: CLLocationCoordinate2D, animated: Bool) {
        fatalError("setCenter(coordinate:) has not been implemented")
    }
    
    func didFindUserLocation(userCoordinate: CLLocationCoordinate2D?) {
        if (isUserLocated == false && userCoordinate != nil) {
            DispatchQueue.main.async {
                guard let coordinate = userCoordinate else {
                    return
                }
                self.setCenter(coordinate: coordinate, animated: false)
            }
            isUserLocated = true
        }
    }
        
}
