//
//  DSLocationUtil.swift
//  DSLocationDemo
//
//  Created by Dream on 2020/12/10.
//

//import UIKit


import CoreLocation.CLLocation

struct DSLocationUtil {
    
}

extension DSLocationUtil {
    
    // MARK:- WGS84 Transform
    
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
    /// - Returns: GCJ02 location
    @discardableResult static func transformWGS84ToGCJ02(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return transformWGS84ToGCJ02(location.latitude, location.longitude)
    }
    
    /// Transform WGS84 to BD09
    /// - Parameters:
    ///   - latitude:  WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: BD09 location
    @discardableResult static func transformWGS84ToBD09(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        let GCJ02 = transformWGS84ToGCJ02(latitude, longitude)
        let BD09  = transformGCJ02ToBD09(GCJ02.latitude, GCJ02.longitude)
        return BD09
    }
    
    /// Transform WGS84 to BD09
    /// - Parameter location: WGS84
    /// - Returns: BD09 location
    @discardableResult static func transformWGS84ToBD09(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let GCJ02 = transformWGS84ToGCJ02(location)
        let BD09  = transformGCJ02ToBD09(GCJ02)
        return BD09
    }
    
    // MARK:- GCJ02 Transform
    
    /// Transform GCJ02 to BD09
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        let pi = Double.pi
        let z = sqrt(longitude * longitude + latitude * latitude) + 0.00002 * sqrt(latitude * pi)
        let t = atan2(latitude, longitude) + 0.000003 * cos(longitude * pi)
        return CLLocationCoordinate2DMake((z * sin(t) + 0.006), (z * cos(t) + 0.0065))
    }
    
    /// Transform GCJ02 to BD09
    /// - Parameter location: GCJ02 location
    /// - Returns: BD09 location
    @discardableResult static func transformGCJ02ToBD09(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return transformGCJ02ToBD09(location.latitude, location.longitude)
    }

    /// Transform GCJ02 to WGS84
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: WGS84 location
    @discardableResult static func transformGCJ02ToWGS84(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let threshold = 0.00001
        // The boundary
        var minLat = location.latitude - 0.5
        var maxLat = location.latitude + 0.5
        var minLng = location.longitude - 0.5
        var maxLng = location.longitude + 0.5
        
        var delta = 1.0
        let maxIteration = 30
        
        // Binary search
        while true {
            let leftBottom  = transformWGS84ToGCJ02(CLLocationCoordinate2D(latitude: minLat, longitude: minLng))
            let rightBottom = transformWGS84ToGCJ02(CLLocationCoordinate2D(latitude: minLat, longitude : maxLng))
            let leftUp      = transformWGS84ToGCJ02(CLLocationCoordinate2D(latitude: maxLat, longitude: minLng))
            let midPoint    = transformWGS84ToGCJ02(CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2))
            delta = fabs(midPoint.latitude - location.latitude) + fabs(midPoint.longitude - location.longitude)
            
            if maxIteration <= 1 || delta <= threshold {
                return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2)
            }
            
            if(isContainsPoint(location, point1: leftBottom, point2: midPoint)) {
                maxLat = (minLat + maxLat) / 2
                maxLng = (minLng + maxLng) / 2
            } else if isContainsPoint(location, point1: rightBottom, point2: midPoint) {
                maxLat = (minLat + maxLat) / 2
                minLng = (minLng + maxLng) / 2
            } else if isContainsPoint(location, point1: leftUp, point2: midPoint) {
                minLat = (minLat + maxLat) / 2
                maxLng = (minLng + maxLng) / 2
            } else {
                minLat = (minLat + maxLat) / 2
                minLng = (minLng + maxLng) / 2
            }
        }
        
    }
    
    /// Transform GCJ02 to WGS84
    /// - Parameters:
    ///   - latitude:  GCJ02 latitude
    ///   - longitude: GCJ02 longitude
    /// - Returns: WGS84 location
    @discardableResult static func transformGCJ02ToWGS84(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        let location  = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return transformGCJ02ToBD09(location)
    }
    
    
    // MARK:- BD09 Transform
    
    /// Transform BD09 to GCJ02
    /// - Parameters:
    ///   - latitude:  BD09 latitude
    ///   - longitude: BD09 longitude
    /// - Returns: GCJ02 location
    @discardableResult static func transformBD09ToGCJ02(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        let xpi = Double.pi * 3000.0 / 180.0
        let x = longitude - 0.0065
        let y = latitude  - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * xpi)
        let t = atan2(y, x) - 0.000003 * cos(x *  xpi)
        return CLLocationCoordinate2DMake(z * sin(t), z * cos(t))
    }
    
    /// Transform BD09 to GCJ02
    /// - Parameter location: BD09 location
    /// - Returns: GCJ02 location
    @discardableResult static func transformBD09ToGCJ02(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return transformBD09ToGCJ02(location.latitude, location.longitude)
    }
    
    
    /// Transform BD09 to WGS84
    /// - Parameters:
    ///   - latitude:  BD09 latitude
    ///   - longitude: BD09 longitude
    /// - Returns: WGS84 location
    @discardableResult static func transformBD09ToWGS84(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees) -> CLLocationCoordinate2D {
        let GCJ02 = transformBD09ToGCJ02(latitude, longitude)
        let WGS84 = transformGCJ02ToWGS84(GCJ02.latitude, GCJ02.longitude)
        return WGS84
    }
    
    
    /// Transform BD09 to WGS84
    /// - Parameter location: BD09 location
    /// - Returns: WGS84 location
    @discardableResult static func transformBD09ToWGS84(_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let GCJ02 = transformBD09ToGCJ02(location)
        let WGS84 = transformGCJ02ToWGS84(GCJ02)
        return WGS84
    }
    
    
    // MARK:- Other
    
    // MARK:- Private
    
    /// transformLatitude
    /// - Parameters:
    ///   - x: latitude   Offset
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
    ///   - x: latitude   Offset
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
    
    /// point is it on point1 and point2
    /// - Parameters:
    ///   - point:  point
    ///   - point1: point1
    ///   - point2: point2
    /// - Returns:
    private static func isContainsPoint(_ point:CLLocationCoordinate2D,  point1:CLLocationCoordinate2D, point2: CLLocationCoordinate2D ) -> Bool  {
        let latitudeIn  = point.latitude  >= min(point1.latitude, point2.latitude) && point.latitude <= max(point1.latitude, point2.latitude)
        let longitudeIn = point.longitude >= min(point1.longitude, point2.longitude) && point.longitude <= max(point1.longitude, point2.longitude)
        return latitudeIn && longitudeIn
    }
    
}
