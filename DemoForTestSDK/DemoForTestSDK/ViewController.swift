//
//  ViewController.swift
//  DemoForTestSDK
//
//  Created by testuser on 2021/7/28.
//

import UIKit
import TestSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TestObjKit.initKit()
        TestObjKit.getHomeVC()
    }


}

