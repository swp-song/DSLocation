//
//  CLLocation+Conversion.swift
//  DSLocation
//
//  Created by Dream on 2021/10/10.
//

import DSBase
import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var conversion: DSLocationConversion {
         return DSLocationConversion.shared
     }
}

extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description: String {
        var string = "\r"
        string.append(" - latitude : \(self.latitude) \r")
        string.append(" - longitude : \(self.longitude) \r")
        string.append(" - coordinate : \(self.longitude),\(self.latitude) \r")
        return string;
    }
}

extension CLLocationCoordinate2D: DSCompatible { }

public extension DS where DSBase == CLLocationCoordinate2D {
    
    // MARK: - WGS84 Conversion, GCJ02 & BD09
    
    /// WGS84 Conversion GCJ02
    var wgs84_gcj02: CLLocationCoordinate2D {
        return ds.conversion.wgs84_gcj02(ds)
    }
    
    /// WGS84 Conversion BD09
    var wgs84_bd09: CLLocationCoordinate2D {
        return ds.conversion.wgs84_bd09(ds)
    }
    
    // MARK: - GCJ02 Conversion, WGS84 & BD09
    
    /// GCJ02 Conversion WGS84
    var gcj02_wgs84: CLLocationCoordinate2D {
        return ds.conversion.gcj02_wgs84(ds)
    }
    
    /// GCJ02 Conversion BD09
    var gcj02_bd09: CLLocationCoordinate2D {
        return ds.conversion.gcj02_bd09(ds)
    }
    
    // MARK: - BD09 Conversion, WGS84 & GCJ02
    
    /// BD09 Conversion WGS84
    var bd09_wgs84: CLLocationCoordinate2D {
        return ds.conversion.bd09_wgs84(ds)
    }
    
    /// BD09 Conversion GCJ02
    var bd09_gcj02: CLLocationCoordinate2D {
        return ds.conversion.bd09_gcj02(ds)
    }
    
}
