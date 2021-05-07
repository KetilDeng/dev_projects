//
//  Hello.swift
//  TestSDK
//
//  Created by testuser on 2021/4/7.
//

import Foundation
import MBProgressHUD
import OCSource

public class Hello {
    var vc: UIViewController?
    public init() {
        // This initializer intentionally left empty
    }
    
    public func hello(_ vc: UIViewController) {
        self.vc = vc
        print("Hello World!")
        MBProgressHUD.showAdded(to: vc.view, animated: true)
        Test.test()
        Dog.dog()
        Cat.cat()
        
        let button = UIButton()
        button.frame = CGRect.init(x: 0, y: 200, width: 100, height: 50)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
        
        vc.view.addSubview(button)
    }
    
    @objc func click(button: UIButton) {
        let fish = FishVC()
        self.vc?.navigationController?.pushViewController(fish, animated: true)
    }
}
