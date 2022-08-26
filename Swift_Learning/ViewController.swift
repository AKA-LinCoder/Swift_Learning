//
//  ViewController.swift
//  Swift_Learning
//
//  Created by lsaac on 2022/4/8.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        LocationTool.shared.getCurrentLocation(isOnce: false) { loc, errorMsg in
            if errorMsg==nil {
                print(loc?.coordinate.latitude as Any)
            }
        }
    }


}

