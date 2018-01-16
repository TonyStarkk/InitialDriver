//
//  InitialDriverTests.swift
//  InitialDriverTests
//
//  Created by Mohamed Ali on 08/01/2018.
//  Copyright © 2018 Mohamed Ali. All rights reserved.
//

import XCTest
import CoreLocation

@testable import InitialDriver

class InitialDriverTests: XCTestCase {
    

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddressInitialisation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let superAddress = "Super Adresse"
        let position = CLLocation(latitude: 4.0, longitude: 5.0)
        let address: Address = Address(position: position, address: superAddress)
        
        XCTAssertTrue(superAddress == address.address
            && position.coordinate.latitude == address.position.coordinate.latitude
            && position.coordinate.longitude == address.position.coordinate.longitude)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
