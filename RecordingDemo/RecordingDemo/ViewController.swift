//
//  ViewController.swift
//  RecordingDemo
//
//  Created by testuser on 2021/5/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.recordButton)
    }
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: self.view.frame.size.width/2 - 50, y: 200, width: 100, height: 50)
        button.setTitle("录音", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(recordClick(button:)), for: .touchUpInside)
        return button
    }()
    
    
    @objc func recordClick(button: UIButton) {
        JZYRecordingView.show()
    }
}
