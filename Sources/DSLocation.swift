//
//  DSLocation.swift
//  Dream
//
//  Created by Dream on 2020/12/8.
//

import Foundation
import CoreLocation

/// - DSLocation
public class DSLocation: NSObject {
    
    // MARK: - DSLocation Internal
    /// CLLocationManager
    lazy var locationManager: CLLocationManager = CLLocationManager()
    /// CLGeocoder, Geocoder
    lazy var geocoder: CLGeocoder = CLGeocoder()
    /// Location, Delete
    weak var delegate: DSLocationManagerDelegate?
    /// LocationMode, Define = WhenInUseAuthorization
    var locationAuthorization: LocationAuthorization = .WhenInUseAuthorization
    /// Location, Start Location, Define = false, 是否开启定位
    var isStartLocation: Bool = false
    /// Location Change Authorization Callback, 定位授权改变回调
    var locationChangeAuthorization: LocationChangeAuthorizationHandler?
    /// Location, Success Callback, 定位成功回调
    var locationSuccess: LocationSuccessHandler?
    /// Location, Error Callback, 定位失败回调
    var locationError: LocationErrorHandler?
    /// Location, Geocode Error Callback, 获取定位信息失败回调
    var locationReverseGeocodeError: LocationReverseGeocodeErrorHandler?

    
    // MARK: - Initialization Method
    
    /// Init DSLocation
    override public init() {
        super.init()
    }
    
    /// Init DSLocation
    /// - Parameter locationMode: LocationMode
     public init(_ locationAuthorization: LocationAuthorization) {
        super.init()
        self.locationAuthorization = locationAuthorization
    }
}

// MARK: -
extension DSLocation  {

    /// 配置定位信息
    func locationConfigure() -> Void {
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch locationAuthorization {
        case .WhenInUseAuthorization:
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .AlwaysAuthorization:
            self.locationManager.requestAlwaysAuthorization()
            break
        }
    }
    
    /// 地理编码, 数据转换, 获取 gcj02, bd09 定位坐标
    /// - Parameters:
    ///   - placemark: placemark
    ///   - location:  location
    /// - Returns: LocationModel
    func reverseGeocodeDataConversion(_ placemark: CLPlacemark, _ location: CLLocation) -> LocationModel {
        let locationModel = LocationModel(placemark, location: location)
        return locationModel
    }
    
    
    /// 地理编码, 根据定位 location 获取定位信息
    /// - Parameters:
    ///   - geocoder:   geocoder
    ///   - location:   location
    func reverseGeocodeLocation(_ geocoder: CLGeocoder, location: CLLocation) {
        
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            
            var messageError: String?

            guard let placemark = placemarks?.first else {
                messageError = "placemarks data parsing error"
                self?.locationReverseGeocodeError?("placemarks data parsing error")
                self?.delegate?.locationReverseGeocodeError?(messageError)
                return
            }
            
            guard let locationModel = self?.reverseGeocodeDataConversion(placemark, location) else {
                messageError = "locationModel data parsing error"
                self?.locationReverseGeocodeError?("placemarks data parsing error")
                self?.delegate?.locationReverseGeocodeError?(messageError)
                return
            }
            
            self?.locationSuccess?(locationModel, error)
            self?.delegate?.locationSuccess?(locationModel, didUpdateLocations: error)
        }
    }
    
}


// MARK: - CLLocation Manager Delegate
extension DSLocation: CLLocationManagerDelegate {
    
    /// CLLocation Delegate 定位授权改变, 调用
    /// - Parameters:
    ///   - manager:CLLocationManager
    ///   - status: CLAuthorizationStatus
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
    
    
    /// CLLocation Delegate 定位更新，调用
    /// - Parameters:
    ///   - manager:     CLLocationManager
    ///   - locations:  [CLLocation]
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ds.stopUpdating()
        
        var messageError: String?
        guard let location = locations.last else {
            messageError = "locations data parsing error"
            self.locationReverseGeocodeError?(messageError)
            self.delegate?.locationReverseGeocodeError?(messageError)
            return
        }
        
        reverseGeocodeLocation(geocoder, location: location);
    }
    
    
    /// CLLocation Delegate, 定位失败，调用
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - error:   Error
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError?(manager, error)
        self.delegate?.locationManager?(manager, didFailWithError: error)
    }
    
}


