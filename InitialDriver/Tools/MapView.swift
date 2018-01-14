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

protocol MapViewDelegate {
    func didChangedRegion(location: CLLocation)
    func isChangingRegion(location: CLLocation)
}

class MapView: UIView {
    var delegate: MapViewDelegate?
    
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
    
    func setCenter(coordinate: CLLocationCoordinate2D) {
        fatalError("setCenter(coordinate:) has not been implemented")
    }
        
}
