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
    
    
    
    lazy var location: DSLocation = {
        var location = DSLocation(.DSLocationRequestWhenInUseAuthorization)
        location.ds.open()
        location.ds.delegate = self
        return location
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.ds.locationChangeAuthorization { (manager, status) in
            print(status)
        }
        
        location.ds.locationSuccess{ (mode, error) in
            print(#function)
            print("wgs84 = \n\(mode.wgs84.longitude),\(mode.wgs84.latitude)")
            print("gcj02 = \n\(mode.gcj02.longitude),\(mode.gcj02.latitude)")
            print("bd09  = \n\(mode.bd09.longitude),\(mode.bd09.latitude)")
        
        }
        
        location.ds.locationError { (manager, error) in
            print(error)
        }
    }
}

extension ViewController: DSLocationDelegate {
    
}
