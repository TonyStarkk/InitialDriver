//
//  Position.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 09/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class Address: NSObject, NSCoding {
    
    var position: CLLocation = CLLocation()
    var address: String = ""
    
    init(position: CLLocation, address: String) {
        self.position = position
        self.address = address
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(position, forKey: "position")
        aCoder.encode(address, forKey: "address")
    }
    
    required init?(coder aDecoder: NSCoder) {
        position = aDecoder.decodeObject(forKey: "position") as! CLLocation
        address = aDecoder.decodeObject(forKey: "address") as! String
    }

}
