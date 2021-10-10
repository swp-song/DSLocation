//
//  ViewController.swift
//  Example
//
//  Created by Dream on 2021/10/8.
//

//  请配置对应的权限：
//  Privacy - Location Always and When In Use Usage Description : 我们需要通过您的地理位置信息获取您周边的相关数据
//  Privacy - Location Always Usage Description                 : 我们需要通过您的地理位置信息获取您周边的相关数据
//  Privacy - Location When In Use Usage Description            : 使用应用期间

//  坐标拾取系统：
//  https://lbs.amap.com/console/show/picker              高德坐标拾取器
//  https://api.map.baidu.com/lbsapi/getpoint/index.html  百度坐标拾取器

import UIKit

import DSLocation
import CoreLocation

class ViewController: UIViewController {

    
    lazy var location: DSLocation = {
        var location = DSLocation(.WhenInUseAuthorization)
        location.ds.open()
        return location
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        location.ds.locationChangeAuthorization { manager, status in
            print("\(status)")
        }
        
        location.ds.locationSuccess { model, error in
            print(model)
            print("wgs84 = \(model.wgs84.longitude),\(model.wgs84.latitude)")
            print("gcj02 = \(model.gcj02.longitude),\(model.gcj02.latitude)")
            print("bd09 = \(model.bd09.longitude),\(model.bd09.latitude)")
            print("1213")
            let d =  CLLocationCoordinate2DMake(39.915107, 116.403933)
            let w = d.ds.bd09_wgs84;
            print(w);
        }
        
        location.ds.locationError { manager, error in
            print(error)
        }
        
    }

}

