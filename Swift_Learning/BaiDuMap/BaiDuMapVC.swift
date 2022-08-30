//
//  BaiDuMapVC.swift
//  Swift_Learning
//
//  Created by lsaac on 2022/8/30.
//

import UIKit
import BaiduMapAPI_Map
import BaiduMapAPI_Base
import BaiduMapAPI_Search
class BaiDuMapVC: UIViewController {
    lazy var mapView:BMKMapView = {
        let map = BMKMapView(frame: self.view.frame)
//        map.delegate = self
        return map
    }()
    lazy var poiSearch:BMKPoiSearch = {
        let poi = BMKPoiSearch()
//        poi.delegate = self
        return poi
    }()
    
    lazy var nearByOption:BMKPOINearbySearchOption = {
        let options = BMKPOINearbySearchOption()
        options.keywords = ["小吃"]
        options.location = CLLocationCoordinate2D(latitude: 39.91927958294124, longitude: 116.41223296776482)
        options.pageIndex = 0
        options.pageSize = 20
        options.radius = 1000
        return options
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(mapView)
        let flag = poiSearch.poiSearchNear(by:nearByOption)
        print("flag:\(flag)")
        
        //导航授权
//        BNCore
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        poiSearch.delegate = self
        mapView.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        poiSearch.delegate = nil
        mapView.delegate = nil
    }
}
extension BaiDuMapVC:BMKMapViewDelegate{
    
}
extension BaiDuMapVC:BMKPoiSearchDelegate{
    
    //点击泡泡时
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        //导航
        //目的地
        let ann = view.annotation
        print("导航到--\(String(describing: ann?.coordinate))")
    }
    
    
    func mapview(_ mapView: BMKMapView!, onLongClick coordinate: CLLocationCoordinate2D) {
        //调整区域
        let region = BMKCoordinateRegion(center: mapView.centerCoordinate, span: BMKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        print(mapView.region.center)
    }
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        if errorCode == BMK_SEARCH_NO_ERROR {
            
            for item in poiResult.poiInfoList {
                print(item.name)
                
                let annotation = BMKPointAnnotation()
                annotation.coordinate = item.pt
                annotation.title = item.name
                annotation.subtitle = item.address
                mapView.addAnnotation(annotation)
            }
        }else{
            print(errorCode)
            print("something wrong")
        }
    }
}
