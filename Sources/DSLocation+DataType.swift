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
        
        ///
        /// - Parameters:
        ///   - placemark:  placemark
        ///   - location:   location
        ///   - wgs84:      wgs84 location
        ///   - gcj02:      gcj02 location
        ///   - bd09:       bd09  location
        init (_ placemark: CLPlacemark, location: CLLocation, wgs84: CLLocationCoordinate2D, gcj02: CLLocationCoordinate2D, bd09: CLLocationCoordinate2D) {
            self.placemark = placemark
            self.location = location
            self.wgs84 = wgs84
            self.gcj02 = gcj02
            self.bd09  = bd09
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
