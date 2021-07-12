//
//  ViewController.swift
//  TestDemo
//
//  Created by testuser on 2021/4/7.
//

import UIKit
import TestSDK

class ViewController: UIViewController {

    @IBOutlet weak var control: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    
    @IBAction func recording(_ sender: UIButton) {
        
    }

    @IBAction func play(_ sender: UIButton) {

    }
    
    @IBAction func go(_ sender: Any) {
        let vc = TestKit.share.getHomeVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
