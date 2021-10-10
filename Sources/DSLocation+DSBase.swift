//
//  DSLocation+DSBase.swift
//  DSLocation
//
//  Created by Dream on 2021/10/9.
//

import DSBase
import CoreLocation

extension DSLocation: DSCompatible { }

// MARK: - Public Property
public extension DS where DSBase: DSLocation {
    
    /// locationManager, CLLocationManager
    var locationManager: CLLocationManager { ds.locationManager }
    
    /// DSLocationManagerDelegate
    weak var delegate: DSLocationManagerDelegate? {
        set { ds.delegate = newValue }
        get { ds.delegate }
    }
    
    /// LocationAuthorization, 定位信息相关数据
    var locationAuthorization: DSLocation.LocationAuthorization {
        set { ds.locationAuthorization = newValue }
        get { ds.locationAuthorization }
    }
    
    /// Location Change Authorizati Callback, 定位授权改变回调
    var locationChangeAuthorization: DSLocation.LocationChangeAuthorizationHandler? {
        set { ds.locationChangeAuthorization = newValue }
        get { ds.locationChangeAuthorization }
    }
    
    /// Location Success Callback, 定位成功回调
    var locationSuccess: DSLocation.LocationSuccessHandler? {
        set { ds.locationSuccess = newValue }
        get { ds.locationSuccess }
    }
    
    /// Location Eerror Callback, 定位失败回调
    var locationError: DSLocation.LocationErrorHandler? {
        set { ds.locationError = newValue }
        get { ds.locationError }
    }
    
    /// Location Reverse Geocode Error Callback, 获取定位信息失败回调
    var locationReverseGeocodeError: DSLocation.LocationReverseGeocodeErrorHandler? {
        set { ds.locationReverseGeocodeError = newValue }
        get { ds.locationReverseGeocodeError }
    }
    
}

// MARK: - Public Method
public extension DS where DSBase: DSLocation {
    
    /// Open Location, 打开定位
    func open() -> Void {
        ds.locationConfigure()
        ds.locationManager.startUpdatingLocation()
    }
    
    /// Start Updating, 定位开始更新
    func startUpdating() -> Void {
        ds.locationManager.startUpdatingLocation()
    }
    
    /// Stop Updating, 定位停止更新
    func stopUpdating() -> Void {
        ds.locationManager.stopUpdatingLocation()
    }
    
    /// Location Change Authorizati Callback, 定位授权改变回调
    /// - Parameter locationChangeAuthorization: LocationChangeAuthorizationHandler
    func locationChangeAuthorization(_ locationChangeAuthorization: @escaping DSLocation.LocationChangeAuthorizationHandler) -> Void {
        ds.locationChangeAuthorization = locationChangeAuthorization
    }
    
    /// Location Success Callback, 定位成功回调
    /// - Parameter locationSuccess: LocationSuccessHandler
    func locationSuccess(_ locationSuccess: @escaping DSLocation.LocationSuccessHandler) -> Void {
        ds.locationSuccess = locationSuccess
    }
    
    /// Location Eerror Callback, 定位失败回调
    /// - Parameter locationError: LocationErrorHandler
    func locationError(_ locationError: @escaping DSLocation.LocationErrorHandler) -> Void {
        ds.locationError = locationError
    }
    
    /// Location Reverse Geocode Error Callback, 获取定位信息失败回调
    /// - Parameter locationReverseGeocodeError: LocationReverseGeocodeErrorHandler
    func locationReverseGeocodeError(_ locationReverseGeocodeError: @escaping DSLocation.LocationReverseGeocodeErrorHandler) {
        ds.locationReverseGeocodeError = locationReverseGeocodeError;
    }
    
}


// MARK: - Location Conversion
public extension DS where DSBase: DSLocation {
    
}
