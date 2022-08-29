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
    lazy var geoCoder:CLGeocoder = {
        let geo = CLGeocoder()
        return geo
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.locationM.requestWhenInUseAuthorization()
        setUpMap()
    
    }
    /*
     理论：
     在地图上操作大头针，实际上操作的是大头针“数据模型”
     删除大头针：移除大头针数据模型
     添加大头针：添加一个大头针数据模型
     */
    
    
    
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
       
//        mapView.showsUserLocation = true
//        mapView.showsScale = true
//        mapView.showsTraffic = true
        //拖动有时没用
//        mapView.userTrackingMode = .followWithHeading
        
        //设置地图代理
//        mapView.delegate = self
        //1.创建一个大头针数据模型
        let annotaion = LinGAnnotation()
        annotaion.coordinate = mapView.centerCoordinate
        annotaion.title = "666"
        annotaion.subtitle = "778"
        
        //2.添加大头针数据模型到地图上
        mapView.addAnnotation(annotaion)
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1.获取所有大头针
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1.获取当前点击的位置，对应的经纬度信息
        guard let point = touches.first?.location(in: mapView) else { return }
        let coordinate =  mapView.convert(point, toCoordinateFrom: mapView)
    
        //2.直接调用自定义方法添加
        let lin =  addAnnotaion(coordinate: coordinate, title: "title", subTitle: "subTitle")
        /*
         先给两个任意字符串用于展位，只有有占位的东西，后面改的才能显示
         */
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { places, error in
            if (error == nil){
                let pl = places?.first
                lin.title = pl?.locality ?? ""
                lin.subtitle = pl?.name ?? ""
                print(pl?.locality ?? "")
            }else{
                print(error?.localizedDescription as Any)
            }
        }
       
    }
    
    
    func addAnnotaion(coordinate:CLLocationCoordinate2D,title:String,subTitle:String) ->LinGAnnotation{
        print("传进来的title:\(title)")
//        print(pl?.name)
        let annotaion = LinGAnnotation()
        annotaion.coordinate = coordinate
        annotaion.title = title
        annotaion.subtitle = subTitle
        
        //2.添加大头针数据模型到地图上
        mapView.addAnnotation(annotaion)
        return annotaion
    }
    
}
extension MapVC:MKMapViewDelegate{
    
    
    
    /// 当地图更新用户位置信息的时候调用
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = "林"
        userLocation.subtitle = "关羽"
    
        //移动地图的中心
//        mapView.setCenter(userLocation.coordinate, animated: true)
        //设置地图显示区域
        let region : MKCoordinateRegion = MKCoordinateRegion.init(center: userLocation.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapView.setRegion(region, animated: true)
    }
    //区域改变时调用
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        mapView.setRegion(<#T##region: MKCoordinateRegion##MKCoordinateRegion#>, animated: <#T##Bool#>)
    }
}
