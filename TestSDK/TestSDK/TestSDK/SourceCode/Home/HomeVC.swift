//
//  HomeVC.swift
//  TestSDK
//
//  Created by testuser on 2021/5/6.
//

import UIKit
import MBProgressHUD
import SnapKit
import OtherFile

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let button = UIButton()
        button.setTitle("添加朋友", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
        let image = UIImage.sdk_init(named: "icon_add_friend")
        button.setImage(image, for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        

        Dog.who()
        Cat.who()
        Labrador.who()
    }
    @objc func click(button: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
}
