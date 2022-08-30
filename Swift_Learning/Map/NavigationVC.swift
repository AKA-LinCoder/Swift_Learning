//
//  NavigationVC.swift
//  Swift_Learning
//
//  Created by Estim on 2022/8/30.
//

import UIKit
import MapKit
class NavigationVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    lazy var geoCoder:CLGeocoder = {
        let geo = CLGeocoder()
        return geo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.mapView.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let circle = MKCircle(center: mapView.centerCoordinate, radius: 100000)
        mapView.addOverlay(circle)
        
        
        geoCoder.geocodeAddressString("广州") { pls, error in
            let startPL = pls?.first
            let startCircle = MKCircle(center: (pls?.first?.location!.coordinate)!, radius: 10000)
            self.mapView.addOverlay(startCircle)
            self.geoCoder.geocodeAddressString("成都") { pls, error in
                let endPL = pls?.first
                let endCircle = MKCircle(center: (endPL?.location!.coordinate)!, radius: 10000)
                self.mapView.addOverlay(endCircle)
//                self.beginNav(startPLCL: startPL!, endPLCL: endPL!)
                self.askNavigation(startPLCL: startPL!, endPLCL: endPL!)
            }
        }
        
        
        
        
    }

    func beginNav(startPLCL:CLPlacemark,endPLCL:CLPlacemark){
        print("start:\(startPLCL)")
        print("end:\(endPLCL)")
        //起点
        let plMK:MKPlacemark = MKPlacemark(placemark: startPLCL)
        let startItem :MKMapItem = MKMapItem(placemark: plMK)
        //终点
        let endMK:MKPlacemark = MKPlacemark(placemark: endPLCL)
        let endItem:MKMapItem = MKMapItem(placemark: endMK)
        let items:[MKMapItem] = [startItem,endItem];
        //导航设置字典
        let launchOtions = [
            MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:MKMapType.standard.rawValue,MKLaunchOptionsShowsTrafficKey:true] as [String : Any]
        MKMapItem.openMaps(with: items, launchOptions: launchOtions)
    }
    
    func askNavigation(startPLCL:CLPlacemark,endPLCL:CLPlacemark){
        let plMK:MKPlacemark = MKPlacemark(placemark: startPLCL)
        let startItem :MKMapItem = MKMapItem(placemark: plMK)
        //终点
        let endMK:MKPlacemark = MKPlacemark(placemark: endPLCL)
        let endItem:MKMapItem = MKMapItem(placemark: endMK)
        let request = MKDirections.Request()
        
        request.source = startItem
        request.destination = endItem
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if(error == nil){
                print("response")
                
                print(response?.routes)
                let routes = response?.routes
                for item in routes! {
//                     name 路线名称
//                    advisoryNotices 提示信息
//                    distance 长度
//                    expectedTravelTime 预计到达时间
//                    transportType 行走方式
//                    polyline 导航路线对应的数据模型
//                    steps 每一步应该怎么走
//                    open class Step : NSObject {
//                        open var instructions: 行走提示：前方路口左转
//                        open var notice: 警告信息
//                        open var polyline:
//                        open var distance: 每一节路径的距离
//                        open var transportType: 方式
                    print(item.name)
                    print(item.distance)
                    self.mapView.addOverlay(item.polyline)
                }
            }else{
                print("error:\(String(describing: error?.localizedDescription))")
            }
        }
    }
    

}

extension NavigationVC:MKMapViewDelegate{
    /**
     当添加一个覆盖层数据模型到地图上时, 地图会调用这个方法, 查找对应的覆盖层"视图"(渲染图层)
     
     - parameter mapView: ditu
     - parameter overlay: 覆盖层"数据模型"
     
     - returns: 覆盖层视图
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if(overlay.isKind(of: MKPolyline.self)){
            // 不同的覆盖层数据模型, 对应不同的覆盖层视图来显示
            let render:MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
            render.lineWidth = 10
            render.strokeColor  = .black
            return render
        }else if(overlay.isKind(of: MKCircle.self)){
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.strokeColor = .blue
            return circleRender
        }else{
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.strokeColor = .blue
            return circleRender
        }


        
        
        
    }
}
