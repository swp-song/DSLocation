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

    @IBOutlet private weak var detailedLabel: UILabel!
    
    lazy var location: DSLocation = {
        var location = DSLocation(.WhenInUseAuthorization)
        location.ds.open()
        location.ds.delegate = self
        return location
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationCallback(location)
    }
    
}

extension ViewController {
    
    @IBAction func selectedStartButton(_ button: UIButton) {
        location.ds.startUpdating()
    }
}

extension ViewController {
    
    func locationCallback(_ location: DSLocation) -> Void {
        
        location.ds.locationChangeAuthorization { manager, status in
            
        }
        
        location.ds.locationSuccess { [weak self] model, error in
            
            print("--------------------------------------------------")
            print(#function)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            self?.detailedLabel.attributedText =  NSMutableAttributedString(string: model.description, attributes: [.paragraphStyle : style, .font : UIFont.systemFont(ofSize: 15)])
            print("--------------------------------------------------")
        }
        
        location.ds.locationError { manager, error in
            
        }
        
    }
}

extension ViewController: DSLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationSuccess(_ model: DSLocation.LocationModel, didUpdateLocations error: Error?) {
        print("--------------------------------------------------")
        print(#function)
        print(model)
        print("--------------------------------------------------")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
}
