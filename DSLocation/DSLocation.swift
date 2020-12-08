//
//  DSLocation.swift
//  DSLocation
//
//  Created by Dream on 2020/12/8.
//

import UIKit
import CoreLocation
import DSBase

public class DSLocation: CLLocationManager {
    
    lazy var locationManager : CLLocationManager = {
        let locationManager = CLLocationManager()
//        locationManager.delegate = self
        return locationManager
    }()
    
    override public init() {
        super.init()
    }
}


public extension DS where DSBase : DSLocation {

    var locationManager : CLLocationManager? {  (self.ds as DSLocation).locationManager }
    
}

public extension DS where DSBase : CLLocationManager {
    
}


extension CLLocationManager : DSCompatible { }




