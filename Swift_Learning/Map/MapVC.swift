//
//  MapVC.swift
//  Swift_Learning
//
//  Created by Estim on 2022/8/28.
//

import UIKit
import MapKit
class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    lazy var locationM: CLLocationManager = {
        let locationm = CLLocationManager()
        locationm.requestWhenInUseAuthorization()
        return locationm
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.locationM.requestWhenInUseAuthorization()
        setUpMap()
    
    }
    
    func setUpMap(){
        //设置地图样式
        //    case standard = 0 标准
        //    case satellite = 1 卫星
        //    case hybrid = 2 标准+卫星
        //    @available(iOS 9.0, *)
        //    case satelliteFlyover = 3 3D立体卫星
        //    @available(iOS 9.0, *)
        //    case hybridFlyover = 4 3D立体混合
        //    @available(iOS 11.0, *)
        //    case mutedStandard = 5 一种强调开发人员数据的模式
        self.mapView.mapType = .standard
        
        //设置地图的控制项
        //        mapView.isScrollEnabled = false
        //        mapView.isRotateEnabled = false
        //        mapView.isZoomEnabled = false
        //设置显示
        //建筑物
//        mapView.showsBuildings = true
        //指南针
//        mapView.showsCompass = true
       
        mapView.showsUserLocation = true
//        mapView.showsScale = true
//        mapView.showsTraffic = true
        //拖动有时没用
//        mapView.userTrackingMode = .followWithHeading
        
        //设置地图代理
        mapView.delegate = self
        
    }
    
}
extension MapVC:MKMapViewDelegate{
    
    /// 当地图更新用户位置信息的时候调用
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = "林"
        userLocation.subtitle = "关羽"
    
        //移动地图的中心
        mapView.setCenter(userLocation.coordinate, animated: true)
    }
}
