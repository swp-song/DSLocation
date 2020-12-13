//
//  ViewController.swift
//  DSLocationDemo
//
//  Created by Dream on 2020/12/8.
//

import UIKit
import CoreLocation
import DSLocation

//  请配置对应的权限：
//  Privacy - Location Always and When In Use Usage Description : 我们需要通过您的地理位置信息获取您周边的相关数据
//  Privacy - Location Always Usage Description                 : 我们需要通过您的地理位置信息获取您周边的相关数据
//  Privacy - Location When In Use Usage Description            : 使用应用期间

//  坐标拾取系统：
//  https://lbs.amap.com/console/show/picker              高德坐标拾取器
//  https://api.map.baidu.com/lbsapi/getpoint/index.html  百度坐标拾取器

class ViewController: UIViewController {
    
    lazy var location: DSLocation = {
        var location = DSLocation(.DSLocationRequestWhenInUseAuthorization)
        location.ds.open()
        location.ds.delegate = self
        return location
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dsLocationClosure()
    }
}


extension ViewController {
    
    func dsLocationClosure() -> Void {
        location.ds.locationChangeAuthorization { (manager, status) in
            print("Closure = \(#function), status = \(status)")
        }
        
        location.ds.locationSuccess{ (model, error) in
            print("Closure = \(#function)")
            print("wgs84 = \n\(model.wgs84.longitude),\(model.wgs84.latitude)")
            print("gcj02 = \n\(model.gcj02.longitude),\(model.gcj02.latitude)")
            print("bd09  = \n\(model.bd09.longitude),\(model.bd09.latitude)")
        }
        
        location.ds.locationError { (manager, error) in
            print("Closure = \(#function)")
        }
    }
}

extension ViewController: DSLocationDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Delegate = \(#function), status = \(status)")
    }
    
    func locationSuccess(_ model: DSLocationModel, didUpdateLocations error: Error?) {
        print("Delegate = \(#function)")
        print("wgs84 = \n\(model.wgs84.longitude),\(model.wgs84.latitude)")
        print("gcj02 = \n\(model.gcj02.longitude),\(model.gcj02.latitude)")
        print("bd09  = \n\(model.bd09.longitude),\(model.bd09.latitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Delegate = \(#function)")
    }
}
