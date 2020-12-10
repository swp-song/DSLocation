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
    
    lazy var geocoder : CLGeocoder = CLGeocoder()
    
    override public init() {
        super.init()
        setup()
    }
    
    func setup() -> Void {
        locationManager.distanceFilter = 300
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
public extension DS where DSBase : DSLocation {

    // MARK: -----------------------------------------
    
    /// Transform WGS84 to GCJ02
    /// - Parameters:
    ///   - latitude:  WGS84 latitude
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
    
    
    /// Transform GCJ02 to BD09
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: BD09 location
    @discardableResult func transformGCJ02ToBD09(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        return Self.transformGCJ02ToBD09(latitude, longitude)
    }
    
    
    /// Transform GCJ02 to BD09
    /// - Parameter location: GCJ02 location
    /// - Returns: BD09 location
    @discardableResult func transformGCJ02ToBD09(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return Self.transformGCJ02ToBD09(location.latitude, location.longitude)
    }
    
}

public extension DS where DSBase : DSLocation  {
    // MARK: --
    
    /// Transform WGS84 to GCJ02
    /// - Parameters:
    ///   - latitude:  WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: GCJ02 location
    @discardableResult static func transformWGS84ToGCJ02(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformWGS84ToGCJ02(latitude, longitude)
    }
    
    /// Transform WGS84 to GCJ02
    /// - Parameter location: WGS84
    /// - Returns: GCJ02
   @discardableResult static func transformWGS84ToGCJ02(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformWGS84ToGCJ02(location.latitude, location.longitude)
   }
    
    /// Transform GCJ02 to BD09
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformGCJ02ToBD09(latitude, longitude)
    }
    
    /// Transform GCJ02 to BD09
    /// - Parameter location: GCJ02 location
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSLocationUtil.transformGCJ02ToBD09(location)
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
        if let location = locations.last {
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first  {
                    let WGS84 = location.coordinate
                    let GCJ02 = self.ds.transformWGS84ToGCJ02(location.coordinate)
                    let BD09  = self.ds.transformGCJ02ToBD09(GCJ02)
                    _ = DSLocationModel(placemark: placemark, WGS84: WGS84, GCJ02: GCJ02, BD09: BD09)
                    print("WGS84 = \n\(WGS84.longitude), \(WGS84.latitude)")
                    print("GCJ02 = \n\(GCJ02.longitude), \(GCJ02.latitude)")
                    print("BD09  = \n\(BD09.longitude), \(BD09.latitude)")
                }
                
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
   
}

extension DSLocation : DSCompatible { }




