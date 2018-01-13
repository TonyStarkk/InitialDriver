//
//  UserDefaults+Extension.swift
//  InitialDriver
//
//  Created by Mohamed Ali on 11/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import SwiftyUserDefaults
import MapKit
extension UserDefaults {
    subscript(key: DefaultsKey<[Address]>) -> [Address] {
        get { return unarchive(key) ?? [] }
        set { archive(key, newValue) }
    }

    subscript(key: DefaultsKey<Address>) -> Address {
        get { return unarchive(key) ?? Address(position: CLLocation(), address: "") }
        set { archive(key, newValue) }
    }
}

extension DefaultsKeys {
    static let arrPosition = DefaultsKey<[Address]>("arrPosition")
}
