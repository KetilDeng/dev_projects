//
//  ViewController.swift
//  TestDemo
//
//  Created by testuser on 2021/4/7.
//

import UIKit
import TestSDK

class ViewController: UIViewController {
    /// 录音管理
    let recorderManagement = JZYAVAudioRecorderManagement()
    ///用于判断当前是开始录音还是完成录音
    var type:Bool = true
    ///界面上的一个按钮-开始录音和完成录音，同一个按钮
    @IBOutlet weak var control: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let _ = recorderManagement.fileSize()
    }
    
    @IBAction func recording(_ sender: UIButton) {
        if type{
            recorderManagement.beginRecord()
            type = false
            control.setTitle("录制中...点击结束", for: .normal)
        }else{
            recorderManagement.stopRecord()
            type = true
            control.setTitle("录音", for: .normal)
        }
    }

    @IBAction func play(_ sender: UIButton) {
        recorderManagement.play()
    }
    
    
    @IBAction func go(_ sender: Any) {
        let vc = TestKit.share.getHomeVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
