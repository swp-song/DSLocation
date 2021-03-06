//
//  DSLocationModel.swift
//  DSLocation
//
//  Created by Dream on 2020/12/10.
//

import Foundation
import CoreLocation.CLPlacemark

public class DSLocationModel: NSObject {
    
    
    /// placemark
    private(set) public var placemark: CLPlacemark
    
    /// location
    private(set) public var location: CLLocation
    
    /// wgs84 location
    private(set) public var wgs84: CLLocationCoordinate2D
    
    /// gcj02 location
    private(set) public var gcj02: CLLocationCoordinate2D
    
    /// bd09  location
    private(set) public var bd09: CLLocationCoordinate2D
    
    
    ///
    /// - Parameters:
    ///   - placemark:  placemark
    ///   - location:   location
    ///   - wgs84:      wgs84 location
    ///   - gcj02:      gcj02 location
    ///   - bd09:       bd09  location
    public init (_ placemark: CLPlacemark, location: CLLocation, wgs84: CLLocationCoordinate2D, gcj02: CLLocationCoordinate2D, bd09: CLLocationCoordinate2D) {
        self.placemark = placemark
        self.location = location
        self.wgs84 = wgs84
        self.gcj02 = gcj02
        self.bd09  = bd09
    }
}
