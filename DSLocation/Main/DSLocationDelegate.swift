//
//  DSLocationDelegate.swift
//  DSLocation
//
//  Created by Dream on 2020/12/11.
//
import CoreLocation

@objc public protocol DSLocationDelegate: NSObjectProtocol {
    @objc optional func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) -> Void
    @objc optional func locationSuccess(_ model: DSLocationModel, didUpdateLocations error: Error?) -> Void
    @objc optional func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) -> Void
    @objc optional func locationReverseGeocodeError(_ messageError: String?) -> Void
}
