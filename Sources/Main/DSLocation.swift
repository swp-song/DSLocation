//
//  DSLocation.swift
//  Dream
//
//  Created by Dream on 2020/12/8.
//

import DSBase
import Foundation
import CoreLocation

extension DSLocation: DSCompatible { }
 
public extension DSLocation {
    
    enum DSLocationMode {
        case DSLocationRequestWhenInUseAuthorization
        case DSLocationRequestAlwaysAuthorization
    }
    
    typealias DSLocationSuccessHandler = (_ model: DSLocationModel, _ error: Error?) -> Void
    typealias DSLocationErrorHandler = (_ manager: CLLocationManager, _ error: Error) -> Void
    typealias DSLocationReverseGeocodeErrorHandler = (_ errorMessage: String?) -> Void
    typealias DSLocationChangeAuthorizationHandler = (_ manager: CLLocationManager, _ status: CLAuthorizationStatus) -> Void
}

public class DSLocation: NSObject {
    
    // MARK: - Private Property
    fileprivate lazy var locationManager: CLLocationManager = CLLocationManager()
    fileprivate lazy var geocoder: CLGeocoder = CLGeocoder()
    fileprivate weak var delegate: DSLocationDelegate?
    fileprivate var locationMode: DSLocationMode = .DSLocationRequestWhenInUseAuthorization
    fileprivate var locationChangeAuthorization: DSLocationChangeAuthorizationHandler?
    fileprivate var locationSuccess: DSLocationSuccessHandler?
    fileprivate var locationError: DSLocationErrorHandler?
    fileprivate var locationReverseGeocodeError: DSLocationReverseGeocodeErrorHandler?
    

    // MARK: - Initialization Method
    
    /// Init DSLocation
    override public init() {
        super.init()
    }
    
    /// Init DSLocation
    /// - Parameter locationMode: DSLocationMode
    public init(_ locationMode: DSLocationMode) {
        super.init()
        self.locationMode = locationMode
    }
    
    // MARK: - Private Method
    
    /// Location Configure
    /// - Returns:
    fileprivate func locationConfigure() -> Void {
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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

// MARK: - Public Property
public extension DS where DSBase: DSLocation {
    
    /// locationManager
    var locationManager: CLLocationManager {
        self.ds.locationManager
    }
    
    /// DSLocationDelegate
    weak var delegate: DSLocationDelegate? {
        set { self.ds.delegate = newValue }
        get { self.ds.delegate }
    }
    
    
    /// DSLocationMode
    var locationMode: DSLocation.DSLocationMode {
        set { self.ds.locationMode = newValue }
        get { self.ds.locationMode }
    }
    
    
    /// Location Change Authorizati Closure
    var locationChangeAuthorization: DSLocation.DSLocationChangeAuthorizationHandler? {
        set { self.ds.locationChangeAuthorization = newValue }
        get { self.ds.locationChangeAuthorization }
    }
    
    
    /// Location Success Closure
    var locationSuccess: DSLocation.DSLocationSuccessHandler? {
        set { self.ds.locationSuccess = newValue }
        get { self.ds.locationSuccess }
    }
    
    /// Location Eerror Closure
    var locationError: DSLocation.DSLocationErrorHandler? {
        set { self.ds.locationError = newValue }
        get { self.ds.locationError }
    }
    
    /// Location Reverse Geocode Error Closure
    var locationReverseGeocodeError: DSLocation.DSLocationReverseGeocodeErrorHandler? {
        set { self.ds.locationReverseGeocodeError = newValue }
        get { self.ds.locationReverseGeocodeError }
    }
    
}

// MARK: - Public Method
public extension DS where DSBase: DSLocation {
    
    /// Open location
    /// - Returns:
    func open() -> Void {
        self.ds.locationConfigure()
        self.ds.locationManager.startUpdatingLocation()
    }
    
    /// Start Updating Location
    /// - Returns:
    func startUpdatingLocation() -> Void {
        self.ds.locationManager.startUpdatingLocation()
    }
    
    /// Stop Updating Location
    /// - Returns:
    func stopUpdatingLocation() -> Void {
        self.ds.locationManager.stopUpdatingLocation()
    }
    
    /// Location Change Authorizati Closure
    /// - Parameter locationChangeAuthorization: DSLocationChangeAuthorizationHandler
    /// - Returns:
    func locationChangeAuthorization(_ locationChangeAuthorization: @escaping DSLocation.DSLocationChangeAuthorizationHandler) -> Void {
        self.ds.locationChangeAuthorization = locationChangeAuthorization
    }
    
    /// Location Success Closure
    /// - Parameter locationSuccess: DSLocationSuccessHandler
    /// - Returns:
    func locationSuccess(_ locationSuccess: @escaping DSLocation.DSLocationSuccessHandler) -> Void {
        self.ds.locationSuccess = locationSuccess
    }
    
    /// Location Eerror Closure
    /// - Parameter locationError: DSLocationErrorHandler
    /// - Returns:
    func locationError(_ locationError: @escaping DSLocation.DSLocationErrorHandler) -> Void {
        self.ds.locationError = locationError
    }
}

// MARK: - CLLocation Manager Delegate
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


