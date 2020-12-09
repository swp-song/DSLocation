//
//  ViewController.swift
//  DSLocationDemo
//
//  Created by Dream on 2020/12/8.
//

import UIKit

import CoreLocation
import DSLocation

class ViewController: UIViewController {

    lazy var locationManager : CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dsLocation = DSLocation()
        
//        dsLocation.ds.locationManager = locationManager
        
        dsLocation.ds.transformWGS84ToGCJ02(CLLocationCoordinate2DMake(0, 0))
        
        DSLocation.ds.transformWGS84ToGCJ02(CLLocationCoordinate2DMake(9, 9))
    }
}


