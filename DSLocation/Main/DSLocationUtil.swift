//
//  DSLocationUtil.swift
//  DSLocationDemo
//
//  Created by Dream on 2020/12/10.
//

import DSBase
import CoreLocation.CLLocation

public extension DS where DSBase: DSLocation {

    // TODO: - WGS84
    
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
    
    // TODO: - GCJ02
    
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
    
    // TODO: - BD09
    
    /// Transform BD09 to GCJ02
    /// - Parameters:
    ///   - latitude:  BD09 latitude
    ///   - longitude: BD09 longitude
    /// - Returns: GCJ02 location
    @discardableResult func transformBD09ToGCJ02(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToGCJ02(latitude, longitude)
    }
    
    /// Transform BD09 to GCJ02
    /// - Parameter location: BD09 location
    /// - Returns: GCJ02 location
    @discardableResult func transformBD09ToGCJ02(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToGCJ02(location)
    }
    
    /// Transform BD09 to WGS84
    /// - Parameters:
    ///   - latitude:  BD09 latitude
    ///   - longitude: BD09 longitude
    /// - Returns: WGS84 location
    @discardableResult func transformBD09ToWGS84(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToWGS84(latitude, longitude)
    }
    
    /// Transform BD09 to WGS84
    /// - Parameter location: BD09 location
    /// - Returns: WGS84 location
    @discardableResult func transformBD09ToWGS84(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToWGS84(location)
    }
    
}


// TODO: - Static
public extension DS where DSBase: DSLocation  {
    
    // TODO: - WGS84
    
    /// Transform WGS84 to GCJ02
    /// - Parameters:
    ///   - latitude:  WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: GCJ02 location
    @discardableResult static func transformWGS84ToGCJ02(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformWGS84ToGCJ02(latitude, longitude)
    }
    
    /// Transform WGS84 to GCJ02
    /// - Parameter location: WGS84
    /// - Returns: GCJ02
   @discardableResult static func transformWGS84ToGCJ02(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformWGS84ToGCJ02(location.latitude, location.longitude)
   }
    
    // TODO: - GCJ02
    
    /// Transform GCJ02 to BD09
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformGCJ02ToBD09(latitude, longitude)
    }
    
    /// Transform GCJ02 to BD09
    /// - Parameter location: GCJ02 location
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformGCJ02ToBD09(location)
    }
    
    // TODO: - BD09
    
    
    /// Transform BD09 to GCJ02
    /// - Parameters:
    ///   - latitude:  BD09 latitude
    ///   - longitude: BD09 longitude
    /// - Returns: GCJ02 location
    @discardableResult static func transformBD09ToGCJ02(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToGCJ02(latitude, longitude)
    }
    
    /// Transform BD09 to GCJ02
    /// - Parameter location: BD09 location
    /// - Returns: GCJ02 location
    @discardableResult static func transformBD09ToGCJ02(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToGCJ02(location)
    }
    
    /// Transform BD09 to WGS84
    /// - Parameters:
    ///   - latitude:  BD09 latitude
    ///   - longitude: BD09 longitude
    /// - Returns: WGS84 location
    @discardableResult static func transformBD09ToWGS84(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToWGS84(latitude, longitude)
    }
    
    /// Transform BD09 to WGS84
    /// - Parameter location: BD09 location
    /// - Returns: WGS84 location
    @discardableResult static func transformBD09ToWGS84(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return DSTransformLocation.transformBD09ToWGS84(location)
    }
    
}

