//
//  DSLocationDelegate.swift
//  DSLocation
//
//  Created by Dream on 2020/12/11.
//
import CoreLocation

@objc public protocol DSLocationDelegate: NSObjectProtocol {
    
    ///  Location Change Authorization
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - status:  CLAuthorizationStatus
    @objc optional func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) -> Void
    
    
    /// Update Locations
    /// - Parameters:
    ///   - model: Location sussess datas
    ///   - error: error
    @objc optional func locationSuccess(_ model: DSLocationModel, didUpdateLocations error: Error?) -> Void
    
    
    ///  Location fail error
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - error:   error
    @objc optional func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) -> Void
    
    
    /// Location reverse geocode error
    /// - Parameter messageError: Error message
    @objc optional func locationReverseGeocodeError(_ messageError: String?) -> Void
}
