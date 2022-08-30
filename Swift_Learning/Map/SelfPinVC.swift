//
//  SelfPinVC.swift
//  Swift_Learning
//
//  Created by Estim on 2022/8/29.
//

import UIKit
import MapKit
class SelfPinVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    lazy var geoCoder:CLGeocoder = {
        let geo = CLGeocoder()
        return geo
    }()
    lazy var locationM:CLLocationManager = {
        let m = CLLocationManager()
        return m
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        //切换追踪模式
        let item = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = item
        self.shotter()
        self.camera()
        self.poi()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1.获取当前点击的位置，对应的经纬度信息
        guard let point = touches.first?.location(in: mapView) else { return }
        let coordinate =  mapView.convert(point, toCoordinateFrom: mapView)
//        mapView.delegate = self
        //2.直接调用自定义方法添加
        let lin =  addAnnotaion(coordinate: coordinate, title: "", subTitle: "")
        /*
         先给两个任意字符串用于展位，只有有占位的东西，后面改的才能显示
         */
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { places, error in
            if (error == nil){
                let pl = places?.first
                lin.title = pl?.locality ?? ""
                lin.subtitle = pl?.name ?? ""
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
    ///地图截图
    func shotter(){
        let option = MKMapSnapshotter.Options()
        option.region = mapView.region
        option.size = CGSize(width: 1000, height: 1000)
        let snapshotter = MKMapSnapshotter(options: option)
        snapshotter.start { shotter, error in
            if(error == nil){
                let image = shotter?.image
                let imageData = UIImage.pngData(image!)
    
                let fileName = "学习笔记.png"
                let fileManager = FileManager.default
                let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
                let path = file! + fileName

                fileManager.createFile(atPath: path, contents:nil, attributes:nil)
                print("文件路径:\(path)")
                let handle = FileHandle(forWritingAtPath:path)
                handle?.write(imageData()!)
//                handle?.write(msg.data(using: String.Encoding.utf8)!)
//                data.writertoF
            }
        }
    }
    
    func camera(){
        let center = mapView.centerCoordinate
        let camera:MKMapCamera = MKMapCamera(lookingAtCenter: center, fromEyeCoordinate: CLLocationCoordinate2DMake(center.latitude, center.longitude), eyeAltitude: 500)
        mapView.setCamera(camera, animated: true)
    }
    
    func poi(){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "小吃"
        request.region = mapView.region
        let search:MKLocalSearch = MKLocalSearch(request: request)
        search.start { response, error in
            if(error == nil){
                let items = response!.mapItems
                for item in items {
                    print(item.name)
                }
            }
        }
    }
    
    
}

extension SelfPinVC:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Placemark"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let imageView = UIImageView(image: UIImage(named: "zhao"))
            imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            //设置左侧视图,如果左右两侧设置了同一个imageView，只会显示右边的
            annotationView?.leftCalloutAccessoryView = imageView
//            annotationView?.rightCalloutAccessoryView = imageView
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.detailCalloutAccessoryView = UISwitch()
            //设置可以拖动
            annotationView?.isDraggable = true
            annotationView?.image = UIImage(named: "map")
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //拿到数据模型
        let ann = view.annotation
        print("选中了\(String(describing: ann?.title ?? ""))")
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        //拿到数据模型
        let ann = view.annotation
        print("取消选中了\(String(describing: ann?.title ?? ""))")
    }
    
    
}
