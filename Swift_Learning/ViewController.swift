//
//  ViewController.swift
//  Swift_Learning
//
//  Created by lsaac on 2022/4/8.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var array:[String] = {
        let array = ["Map使用","自定义大头针","使用系统app导航"]
        return array
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        view.addSubview(self.tableView);
        LocationTool.shared.getCurrentLocation(isOnce: false) { loc, errorMsg in
            if errorMsg==nil {
                print(loc?.coordinate.latitude as Any)
            }
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.array[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = MapVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(indexPath.row == 1){
            let vc = SelfPinVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(indexPath.row == 2){
            let vc = NavigationVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

