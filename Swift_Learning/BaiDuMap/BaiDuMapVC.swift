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
        options.keywords = ["按摩店"]
        options.location = mapView.centerCoordinate
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
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        if errorCode == BMK_SEARCH_NO_ERROR {
            
            for item in poiResult.poiInfoList {
                print(item.name)
            }
        }else{
            print(errorCode)
            print("something wrong")
        }
    }
}
