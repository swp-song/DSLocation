//
//  DSLocationModel.swift
//  DSLocation
//
//  Created by Dream on 2020/12/10.
//

import CoreLocation.CLPlacemark

 public struct DSLocationModel {

    private(set) public var placemark : CLPlacemark
    private(set) public var WGS84 : CLLocationCoordinate2D
    private(set) public var GCJ02 : CLLocationCoordinate2D
    private(set) public var BD09  : CLLocationCoordinate2D
    
    public init (placemark : CLPlacemark,  WGS84 : CLLocationCoordinate2D, GCJ02 : CLLocationCoordinate2D, BD09 : CLLocationCoordinate2D) {
        self.placemark = placemark
        self.WGS84 = WGS84
        self.GCJ02 = GCJ02
        self.BD09  = BD09
    }
}
