//
//  DSLocation.swift
//  DSLocation
//
//  Created by Dream on 2020/12/8.
//

import UIKit
import DSBase
import CoreLocation

open class DSLocation: NSObject {
    
    public enum DSLocationMode {
        case DSLocationRequestWhenInUseAuthorization
        case DSLocationRequestAlwaysAuthorization
    }
    
    public typealias DSLocationSuccessHandler = (_ model: DSLocationModel, _ error: Error?) -> Void
    public typealias DSLocationErrorHandler = (_ manager: CLLocationManager, _ error: Error) -> Void
    public typealias DSLocationReverseGeocodeErrorHandler = (_ errorMessage: String?) -> Void
    public typealias DSLocationChangeAuthorizationHandler = (_ manager: CLLocationManager, _ status: CLAuthorizationStatus) -> Void
    
    lazy var locationManager: CLLocationManager = CLLocationManager()
    var locationMode: DSLocationMode = .DSLocationRequestWhenInUseAuthorization
    lazy var geocoder: CLGeocoder = CLGeocoder()
    weak var delegate: DSLocationDelegate?
    
    var locationChangeAuthorization: DSLocationChangeAuthorizationHandler?
    var locationSuccess: DSLocationSuccessHandler?
    var locationError: DSLocationErrorHandler?
    var locationReverseGeocodeError: DSLocationReverseGeocodeErrorHandler?

    
    override public init() {
        super.init()
    }
    
    public init(_ locationMode: DSLocationMode) {
        super.init()
        self.locationMode = locationMode
    }
    
    func configure() -> Void {
        locationManager.distanceFilter = 300
        locationManager.delegate = self
        switch self.ds.locationMode {
        case .DSLocationRequestWhenInUseAuthorization:
            self.ds.locationManager.requestWhenInUseAuthorization()
            break
        case .DSLocationRequestAlwaysAuthorization:
            self.ds.locationManager.requestAlwaysAuthorization()
            break
        }
    }
}


public extension DS where DSBase: DSLocation {
    
    var locationManager: CLLocationManager {
        self.ds.locationManager
    }
    
    weak var delegate: DSLocationDelegate? {
        set { self.ds.delegate = newValue }
        get { self.ds.delegate }
    }
    
    var locationMode: DSLocation.DSLocationMode {
        set { self.ds.locationMode = newValue }
        get { self.ds.locationMode }
    }
    
    var locationChangeAuthorization: DSLocation.DSLocationChangeAuthorizationHandler? {
        set { self.ds.locationChangeAuthorization = newValue }
        get { self.ds.locationChangeAuthorization }
    }
    
    var locationSuccess: DSLocation.DSLocationSuccessHandler? {
        set { self.ds.locationSuccess = newValue }
        get { self.ds.locationSuccess }
    }
    
    var locationReverseGeocodeError: DSLocation.DSLocationReverseGeocodeErrorHandler? {
        set { self.ds.locationReverseGeocodeError = newValue }
        get { self.ds.locationReverseGeocodeError }
    }
    
    var locationError: DSLocation.DSLocationErrorHandler? {
        set { self.ds.locationError = newValue }
        get { self.ds.locationError }
    }
}


public extension DS where DSBase: DSLocation {
    
    func open() -> Void {
        self.ds.configure()
        self.ds.locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() -> Void {
        self.ds.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() -> Void {
        self.ds.locationManager.stopUpdatingLocation()
    }
    
    func locationChangeAuthorization(_ locationChangeAuthorization: @escaping DSLocation.DSLocationChangeAuthorizationHandler) -> Void {
        self.ds.locationChangeAuthorization = locationChangeAuthorization
    }
    
    func locationSuccess(_ locationSuccess: @escaping DSLocation.DSLocationSuccessHandler) -> Void {
        self.ds.locationSuccess = locationSuccess
    }
    
    func locationError(_ locationError: @escaping DSLocation.DSLocationErrorHandler) -> Void {
        self.ds.locationError = locationError
    }
    
    
    
}

public extension DS where DSBase: DSLocation {

    // MARK: -----------------------------------------
    
    /// Transform WGS84 to GCJ02
    /// - Parameters:
    ///   - latitude:  WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: GCJ02 location
    @discardableResult func transformWGS84ToGCJ02(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return Self.transformWGS84ToGCJ02(latitude, longitude);
    }
    
    
    /// Transform WGS84 to GCJ02
    /// - Parameter location: WGS84 location
    /// - Returns: GCJ02 location
    @discardableResult func transformWGS84ToGCJ02(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return Self.transformWGS84ToGCJ02(location);
    }
    
    
    /// Transform GCJ02 to BD09
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: BD09 location
    @discardableResult func transformGCJ02ToBD09(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return Self.transformGCJ02ToBD09(latitude, longitude)
    }
    
    
    /// Transform GCJ02 to BD09
    /// - Parameter location: GCJ02 location
    /// - Returns: BD09 location
    @discardableResult func transformGCJ02ToBD09(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return Self.transformGCJ02ToBD09(location.latitude, location.longitude)
    }
    
}

public extension DS where DSBase: DSLocation  {
    // MARK: --
    
    /// Transform WGS84 to GCJ02
    /// - Parameters:
    ///   - latitude:  WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: GCJ02 location
    @discardableResult static func transformWGS84ToGCJ02(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformWGS84ToGCJ02(latitude, longitude)
    }
    
    /// Transform WGS84 to GCJ02
    /// - Parameter location: WGS84
    /// - Returns: GCJ02
   @discardableResult static func transformWGS84ToGCJ02(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformWGS84ToGCJ02(location.latitude, location.longitude)
   }
    
    /// Transform GCJ02 to BD09
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformGCJ02ToBD09(latitude, longitude)
    }
    
    /// Transform GCJ02 to BD09
    /// - Parameter location: GCJ02 location
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformGCJ02ToBD09(location)
    }
    
}


extension DSLocation: CLLocationManagerDelegate {
    
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        default:
            break
        }
        
        self.locationChangeAuthorization?(manager, status)
        self.delegate?.locationManager?(manager, didChangeAuthorization: status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        var messageError: String?
        guard let location = locations.last else {
            messageError = "locations data parsing error"
            self.locationReverseGeocodeError?(messageError)
            self.delegate?.locationReverseGeocodeError?(messageError)
            return
        }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let placemark = placemarks?.first else {
                messageError = "placemarks data parsing error"
                self?.locationReverseGeocodeError?("placemarks data parsing error")
                self!.delegate?.locationReverseGeocodeError?(messageError)
                return
            }
            guard let locationModel = self?.reverseGeocodeDataPacking(placemark, location) else {
                messageError = "locationModel data parsing error"
                self?.locationReverseGeocodeError?("placemarks data parsing error")
                self?.delegate?.locationReverseGeocodeError?(messageError)
                return
            }
            self?.locationSuccess?(locationModel, error)
            self?.delegate?.locationSuccess?(locationModel, didUpdateLocations: error)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError?(manager, error)
        self.delegate?.locationManager?(manager, didFailWithError: error)
    }
    
    private func reverseGeocodeDataPacking(_ placemark: CLPlacemark, _ location: CLLocation) -> DSLocationModel {
        let wgs84 = location.coordinate
        let gcj02 = self.ds.transformWGS84ToGCJ02(location.coordinate)
        let bd09  = self.ds.transformGCJ02ToBD09(gcj02)
        let locationModel = DSLocationModel(placemark, location: location, wgs84: wgs84, gcj02: gcj02, bd09: bd09)
        return locationModel
    }
    
}

extension DSLocation: DSCompatible { }
