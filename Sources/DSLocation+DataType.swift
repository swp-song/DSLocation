//
//  DSLocationDefine.swift
//  Dream
//
//  Created by Dream on 2021/10/9.
//

import Foundation
import CoreLocation

public extension DSLocation {
        
    /// Location Authorization, 定位 Mode
    enum LocationAuthorization {
        /// - WhenInUseAuthorization    使用时授权
        case WhenInUseAuthorization
        /// - AlwaysAuthorization,      始终授权
        case AlwaysAuthorization
    }
    
    /// Location Model
    class LocationModel: NSObject {

        /// placemark
        private(set) public var placemark: CLPlacemark
        /// location
        private(set) public var location: CLLocation
        /// wgs84 location
        private(set) public var wgs84: CLLocationCoordinate2D
        /// gcj02 location
        private(set) public var gcj02: CLLocationCoordinate2D
        /// latitude and longitude, bd09  location
        private(set) public var bd09: CLLocationCoordinate2D
        
        init (_ placemark: CLPlacemark, location: CLLocation) {
    
            self.placemark = placemark
            self.location  = location
            self.wgs84     = location.coordinate
            self.gcj02     = self.wgs84.ds.wgs84_gcj02
            self.bd09      = self.gcj02.ds.gcj02_bd09
            
        }
        
        public override var description: String {
            var string = ""
            
            string.append("wgs84 = \(self.wgs84) \r")
            string.append("gcj02 = \(self.gcj02) \r")
            string.append("bd09  = \(self.bd09)  \r")
            string.append("Address = ")
        
            if let name = self.placemark.name {
                string.append("\(name), ")
            }
            
            if let country = self.placemark.country {
                string.append("\(country)")
            }
            
            if let administrativeArea = self.placemark.administrativeArea {
                string.append("\(administrativeArea)")
            }
            
            if let city = self.placemark.locality {
                string.append("\(city)")
            }
    
            if let subLocality = self.placemark.subLocality {
                string.append("\(subLocality)")
            }
            
            if let thoroughfare = self.placemark.thoroughfare {
                string.append("\(thoroughfare)")
            }
            
            return string;
        }
    }
    
    /// Location Change Authorization Callback, 定位授权改变回调
    typealias LocationChangeAuthorizationHandler = (_ manager: CLLocationManager, _ status: CLAuthorizationStatus) -> Void
    /// Location, Success Callback, 定位成功回调
    typealias LocationSuccessHandler = (_ model: LocationModel, _ error: Error?) -> Void
    /// Location, Error Callback, 定位失败回调
    typealias LocationErrorHandler = (_ manager: CLLocationManager, _ error: Error) -> Void
    /// Location, Geocode Error Callback, 获取定位信息失败回调
    typealias LocationReverseGeocodeErrorHandler = (_ errorMessage: String?) -> Void

}
