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
    
    lazy var location = DSLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.ds.locationMode = .DSLocationRequestAlwaysAuthorization
//        location.ds.locationManager.delegate = self
        location.ds.startUpdatingLocation()
//        location.didUpdateLocations
    }
}



//extension ViewController : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//    }
//}

