//
//  DSLocationConversion.swift
//  DSLocation
//
//  Created by Dream on 2021/10/10.
//

import DSBase
import Foundation
import CoreLocation.CLLocation

struct DSLocationConversion {
    
    static let shared = DSLocationConversion()
    
    private init() { }
}

// MARK: - WGS84 Conversion GCJ02
extension DSLocationConversion {
    
    /// Conversion WGS84 to GCJ02
    /// - Parameter coordinate: WGS84 Coordinate
    /// - Returns: GCJ02 Coordinate
    @discardableResult func wgs84_gcj02(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let a = 6378245.0
        let e = 0.00669342162296594323
        let pi = Double.pi

        let wgs84Latitude  = coordinate.latitude
        let wgs84Longitude = coordinate.longitude

        var aLatitude  = conversionLatitude(wgs84Longitude - 105.0, wgs84Latitude - 35.0)
        var aLongitude = conversionLongitude(wgs84Longitude - 105.0, wgs84Latitude - 35.0)

        let radLat = wgs84Latitude / 180.0 * pi
        var magic  = sin(radLat)
        magic = 1 - e * magic * magic
        let sqrtMagic = sqrt(magic)
        aLatitude  = (aLatitude * 180.0) / ((a * (1 - e)) / (magic * sqrtMagic) * pi)
        aLongitude = (aLongitude * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
        return CLLocationCoordinate2DMake(wgs84Latitude + aLatitude, wgs84Longitude + aLongitude)
    }
    
    /// Transform WGS84 to BD09
    /// - Parameters:
    ///   - latitude:  WGS84 latitude
    ///   - longitude: WGS84 longitude
    /// - Returns: BD09 location
    @discardableResult func wgs84_bd09(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let gcj02 = wgs84_gcj02(coordinate)
        let bd09  = gcj02_bd09(gcj02)
        return bd09
    }
    
    /// conversionLatitude
    /// - Parameters:
    ///   - x: latitude   Offset
    ///   - y: longtitude Offset
    /// - Returns: latitude
    private func conversionLatitude(_ x: Double, _ y: Double) -> Double {
        
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
    
    /// conversionLongitude
    /// - Parameters:
    ///   - x: latitude   Offset
    ///   - y: longtitude Offset
    /// - Returns: longtitude
    private func conversionLongitude(_ x: Double, _ y: Double) -> Double {
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

// MARK: - GCJ02 Conversion
extension DSLocationConversion {
        
    ///  GCJ02 Conversion WGS84
    /// - Parameter coordinate: GCJ02 Coordinate
    /// - Returns: WGS84 Coordinate
    @discardableResult
    func gcj02_wgs84(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let threshold = 0.00001
        // The boundary
        var minLat = coordinate.latitude - 0.5
        var maxLat = coordinate.latitude + 0.5
        var minLng = coordinate.longitude - 0.5
        var maxLng = coordinate.longitude + 0.5
        
        var delta = 1.0
        let maxIteration = 30
        
        // search
        while true {
            
            let leftBottom  = wgs84_gcj02(CLLocationCoordinate2D(latitude: minLat, longitude: minLng))
            let rightBottom = wgs84_gcj02(CLLocationCoordinate2D(latitude: minLat, longitude: maxLng))
            let leftUp      = wgs84_gcj02(CLLocationCoordinate2D(latitude: maxLat, longitude: minLng))
            let midPoint    = wgs84_gcj02(CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2))
            delta = fabs(midPoint.latitude - coordinate.latitude) + fabs(midPoint.longitude - coordinate.longitude)
            
            if maxIteration <= 1 || delta <= threshold {
                return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2)
            }
            
            if (isContainsPoint(coordinate, point1: leftBottom, point2: midPoint)) {
                maxLat = (minLat + maxLat) / 2
                maxLng = (minLng + maxLng) / 2
            } else if isContainsPoint(coordinate, point1: rightBottom, point2: midPoint) {
                maxLat = (minLat + maxLat) / 2
                minLng = (minLng + maxLng) / 2
            } else if isContainsPoint(coordinate, point1: leftUp, point2: midPoint) {
                minLat = (minLat + maxLat) / 2
                maxLng = (minLng + maxLng) / 2
            } else {
                minLat = (minLat + maxLat) / 2
                minLng = (minLng + maxLng) / 2
            }
        }
    }
    
    /// GCJ02 Conversion BD09
    /// - Parameter coordinate: GCJ02 Coordinate
    /// - Returns:  BD09 Coordinate
    @discardableResult
    func gcj02_bd09(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let latitude  = coordinate.latitude
        let longitude = coordinate.longitude
        let pi = Double.pi
        let z = sqrt(longitude * longitude + latitude * latitude) + 0.00002 * sqrt(latitude * pi)
        let t = atan2(latitude, longitude) + 0.000003 * cos(longitude * pi)
        return CLLocationCoordinate2DMake((z * sin(t) + 0.006), (z * cos(t) + 0.0065))
    }
    
    /// Point is it on point1 and point2
    /// - Parameters:
    ///   - point:  point
    ///   - point1: point1
    ///   - point2: point2
    /// - Returns: isContains
    func isContainsPoint(_ point:CLLocationCoordinate2D,  point1:CLLocationCoordinate2D, point2: CLLocationCoordinate2D ) -> Bool  {
        let latitudeIn  = point.latitude  >= min(point1.latitude, point2.latitude) && point.latitude <= max(point1.latitude, point2.latitude)
        let longitudeIn = point.longitude >= min(point1.longitude, point2.longitude) && point.longitude <= max(point1.longitude, point2.longitude)
        return latitudeIn && longitudeIn
    }
    
}

// MARK: - BD09 Conversion GCJ02
extension DSLocationConversion {
        
    ///  BD09 Conversion WGS84
    /// - Parameter coordinate: BD09 Coordinate
    /// - Returns: WGS84 Coordinate
    @discardableResult
    func bd09_wgs84(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let gcj02 = bd09_gcj02(coordinate)
        let wgs84 = gcj02_wgs84(gcj02)
        return wgs84;
    }
    
    ///  BD09 Conversion GCJ02
    ///  BD09 Conversion GCJ02
    /// - Parameter coordinate: BD09 Coordinate
    /// - Returns: GCJ02 Coordinate
    @discardableResult
    func bd09_gcj02(_ coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let xpi = Double.pi * 3000.0 / 180.0
        let x = coordinate.longitude - 0.0065
        let y = coordinate.latitude  - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * xpi)
        let t = atan2(y, x) - 0.000003 * cos(x *  xpi)
        return CLLocationCoordinate2DMake(z * sin(t), z * cos(t))
    }
    
}



