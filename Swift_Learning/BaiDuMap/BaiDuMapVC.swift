//
//  BaiDuMapVC.swift
//  Swift_Learning
//
//  Created by lsaac on 2022/8/30.
//

import UIKit
import BaiduMapAPI_Map
class BaiDuMapVC: UIViewController {
    lazy var mapView:BMKMapView = {
        let map = BMKMapView(frame: self.view.frame)
        map.delegate = self
        return map
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mapView)
    }
}
extension BaiDuMapVC:BMKMapViewDelegate{
    
}
