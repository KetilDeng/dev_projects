//
//  ViewController.swift
//  DKTMarquee
//
//  Created by testuser on 2021/5/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataArray = ["①这是第一个",
                         "②这是第二个第二个",
                         "③这是第三个这是第三个",
                         "④四",
                         "⑤第五个"
        ]
        
        let view4 = DKTMarquee.init(frame: CGRect.init(x: 100, y: 200, width: self.view.bounds.size.width-200, height: 50))
        view4.backgroundColor = .blue
        view4.config(datas: dataArray)
        view.addSubview(view4)
    }


}

