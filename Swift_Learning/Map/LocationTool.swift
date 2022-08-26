//
//  LocationTool.swift
//  Swift_Learning
//
//  Created by lsaac on 2022/8/26.
//

import UIKit
import CoreLocation

typealias LocationResultBlock = (_ loc:CLLocation?,_ errorMsg:String?)->()
class LocationTool: NSObject {
    static let shared = LocationTool()
    
    
    var isOnce = false
    
    lazy var locationM:CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        //请求授权
        //1.先获取info文件内容
        guard let infoDict = Bundle.main.infoDictionary else{
            return manager
        }
        //2.获取前台定位授权的key值
        let whenInUse = infoDict["NSLocationWhenInUseUsageDescription"];
        //3.获取前后台定位授权的key值
        let always = infoDict["NSLocationAlwaysAndWhenInUseUsageDescription"];
        if (always != nil && whenInUse != nil){
            manager.requestAlwaysAuthorization()
        }else if(whenInUse != nil){
            manager.requestWhenInUseAuthorization()
            //判断后台模式有没有勾选location updates
            //判断当前版本是iOS9，只有9以后才需要设置
            let backModes = infoDict["UIBackgroundModes"]
            if(backModes != nil){
                let resultBackModel = backModes as! [String]
                if(resultBackModel.contains("location")){
                    if #available(iOS 9.0, *){
                        manager.allowsBackgroundLocationUpdates = true
                    }
                }
            }
        }else{
            print("错误提示：没有在info.list文件中配置key")
        }
        return manager
    }()

    var resultBlock:LocationResultBlock?
    
    func getCurrentLocation(isOnce:Bool,result: @escaping LocationResultBlock)->() {
        //1.记录block
        self.resultBlock = result;
        self.isOnce = isOnce;
        //2.在合适的地方执行
        if(CLLocationManager.locationServicesEnabled()){
            self.locationM.startUpdatingLocation()
        }else{
            if(self.resultBlock != nil){
                self.resultBlock!(nil,"定位服务不可用")
            }
           
        }
      
       
    }
}

extension LocationTool:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locs = locations.last else {
            if(resultBlock != nil){
                resultBlock!(nil,"获取不到数据")
            }
            return
           
        }
        resultBlock!(locs,nil)
        if(self.isOnce){
            self.locationM.stopUpdatingLocation()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //判断有没有达到10s
        self.locationM.startUpdatingLocation()
    }
    
    
    @available(iOS 14, *) func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let resultBlock = resultBlock else {return}
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            resultBlock(nil,"用户没有决定")
        case .restricted:
            resultBlock(nil,"当前受限制")
        case .denied:
            resultBlock(nil,"当前被拒绝")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let resultBlock = resultBlock else {return}
        
        switch status {
        case .notDetermined:
            resultBlock(nil,"用户没有决定")
        case .restricted:
            resultBlock(nil,"当前受限制")
        case .denied:
            resultBlock(nil,"当前被拒绝")
        default:
            break
        }
    }
    
}
