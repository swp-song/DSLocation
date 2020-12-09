//
//  DSLocation.swift
//  DSLocation
//
//  Created by Dream on 2020/12/8.
//

import UIKit
import DSBase
import CoreLocation

public enum DSLocationMode {
    case DSLocationRequestWhenInUseAuthorization
    case DSLocationRequestAlwaysAuthorization
}
open class DSLocation: NSObject {
    
    lazy var locationManager : CLLocationManager = CLLocationManager()
    var locationMode : DSLocationMode = .DSLocationRequestWhenInUseAuthorization
    
    override public init() {
        super.init()
        
//        if #available(iOS 14.0, *) {
////            self.ds.locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "precise")
//            self.ds.locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "precise") { (error) in
//
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        setup()
    }
    
    func setup() -> Void {
        locationManager.distanceFilter = 300
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 14.0, *) {
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "precise") { (error) in
                print(error)
            }
        } else {
            // Fallback on earlier versions
        }
        locationManager.delegate = self
    }
}


public extension DS where DSBase : DSLocation {
    var locationManager : CLLocationManager {
        self.ds.locationManager
    }
    
    var locationMode : DSLocationMode {
        set { self.ds.locationMode = newValue }
        get { self.ds.locationMode }
    }
}

public extension DS where DSBase : DSLocation {

    // MARK: -----------------------------------------
    
    /// Transform WGS84 to GCJ02
    /// - Parameters:
    ///   - latitude: WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: GCJ02 location
    @discardableResult func transformWGS84ToGCJ02(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        return Self.transformWGS84ToGCJ02(latitude, longitude);
    }
    
    
    /// Transform WGS84 to GCJ02
    /// - Parameter location: WGS84 location
    /// - Returns: GCJ02 location
    @discardableResult func transformWGS84ToGCJ02(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return Self.transformWGS84ToGCJ02(location);
    }
    
    func startUpdatingLocation() -> Void {
        
        switch self.ds.locationMode {
        case .DSLocationRequestWhenInUseAuthorization:
            self.ds.locationManager.requestWhenInUseAuthorization()
            break
        case .DSLocationRequestAlwaysAuthorization:
            self.ds.locationManager.requestAlwaysAuthorization()
            break
        }
        
        self.ds.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() -> Void {
        self.ds.locationManager.stopUpdatingLocation()
    }
    
}

public extension DS where DSBase : DSLocation  {
    // MARK: --
    
    
    /// Transform WGS84 to GCJ02
    /// - Parameters:
    ///   - latitude: WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: GCJ02 location
    @discardableResult static func transformWGS84ToGCJ02(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        let a = 6378245.0
        let e = 0.00669342162296594323
        let pi = Double.pi

        let wgs84Latitude  = latitude
        let wgs84Longitude = longitude

        var aLatitude  = transformLatitude(wgs84Longitude - 105.0, wgs84Latitude - 35.0)
        var aLongitude = transformLongitude(wgs84Longitude - 105.0, wgs84Latitude - 35.0)

        let radLat = wgs84Latitude / 180.0 * pi
        var magic  = sin(radLat)
        magic = 1 - e * magic * magic
        let sqrtMagic = sqrt(magic)
        aLatitude  = (aLatitude * 180.0) / ((a * (1 - e)) / (magic * sqrtMagic) * pi)
        aLongitude = (aLongitude * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
        return CLLocationCoordinate2DMake(wgs84Latitude + aLatitude, wgs84Longitude + aLongitude)
    }
    
    /// Transform WGS84 to GCJ02
    /// - Parameter location: WGS84
    /// - Returns: GCJ02
   @discardableResult static func transformWGS84ToGCJ02(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return transformWGS84ToGCJ02(location.latitude, location.longitude)
    }
}

private extension DS where DSBase : DSLocation {
    
    /// transformLatitude
    /// - Parameters:
    ///   - x: latitude Offset
    ///   - y: longtitude Offset
    /// - Returns: latitude
    private static func transformLatitude(_ x : Double, _ y : Double) -> Double {
        
        let pi = Double.pi
        var latitude = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y
        latitude += 0.2 * sqrt(fabs(x))
        
        latitude += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0
        latitude += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        latitude += (20.0 * sin(y * pi)) * 2.0 / 3.0
        latitude += (40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
        latitude += (160.0 * sin(y / 12.0 * pi)) * 2.0 / 3.0
        latitude += (320 * sin(y * pi / 30.0)) * 2.0 / 3.0
        return latitude
    }
    
    /// transformLongitude
    /// - Parameters:
    ///   - x: latitude Offset
    ///   - y: longtitude Offset
    /// - Returns: longtitude
    private static func transformLongitude(_ x : Double, _ y : Double) -> Double {
        let pi = Double.pi
        var longtitude = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y
        longtitude +=  0.1 * sqrt(fabs(x))
        longtitude += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0
        longtitude += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        longtitude += (20.0 * sin(x * pi)) * 2.0 / 3.0
        longtitude += (40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
        longtitude += (150.0 * sin(x / 12.0 * pi)) * 2.0 / 3.0
        longtitude += (300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
        return longtitude
    }
}


extension DSLocation : CLLocationManagerDelegate {
    
    
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
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.ds.stopUpdatingLocation()
        if let location = locations.first {
            print(location)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
   
}

extension DSLocation : DSCompatible { }




