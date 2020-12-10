//
//  ViewController.swift
//  DSLocationDemo
//
//  Created by Dream on 2020/12/8.
//

import UIKit
import CoreLocation
import DSLocation

class ViewController: UIViewController {
    
    
    
    //  请配置对应的权限：
    //  Privacy - Location Always and When In Use Usage Description : 我们需要通过您的地理位置信息获取您周边的相关数据
    //  Privacy - Location Always Usage Description                 : 我们需要通过您的地理位置信息获取您周边的相关数据
    //  Privacy - Location When In Use Usage Description            : 使用应用期间
    
    //  坐标拾取系统：
    //  https://lbs.amap.com/console/show/picker              高德坐标拾取器
    //  https://api.map.baidu.com/lbsapi/getpoint/index.html  百度坐标拾取器
    
    
    
    lazy var location = DSLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.ds.locationMode = .DSLocationRequestAlwaysAuthorization
//        location.ds.locationManager.delegate = self
        location.ds.startUpdatingLocation()
        let l =  CLLocationCoordinate2DMake(0, 0)
//        let p = DSLocationModel(placemark: CLPlacemark(), WGS84: l, GCJ02: l, BD09: l)
        
//        location.didUpdateLocations
    }
}



//extension ViewController : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//    }
//}

