//
//  NavigationVC.swift
//  Swift_Learning
//
//  Created by Estim on 2022/8/30.
//

import UIKit
import MapKit
class NavigationVC: UIViewController {

    lazy var geoCoder:CLGeocoder = {
        let geo = CLGeocoder()
        return geo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        geoCoder.geocodeAddressString("广州") { pls, error in
            let startPL = pls?.first
            self.geoCoder.geocodeAddressString("成都") { pls, error in
                let endPL = pls?.first
              
                self.beginNav(startPLCL: startPL!, endPLCL: endPL!)
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

}
