//
//  LinGAnnotation.swift
//  Swift_Learning
//
//  Created by Estim on 2022/8/28.
//

import UIKit
import MapKit
class LinGAnnotation: NSObject,MKAnnotation {
    //确定大头针扎在哪个位置
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String?
    var subtitle: String?
    

    
}
