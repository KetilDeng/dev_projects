//
//  ViewController.swift
//  TestDemo
//
//  Created by testuser on 2021/4/7.
//

import UIKit
//import TestSDK

class ViewController: UIViewController {
    /// 录音管理
    let recorderManagement = JZYRecordingManagement()
    ///用于判断当前是开始录音还是完成录音
    var type:Bool = true
    ///界面上的一个按钮-开始录音和完成录音，同一个按钮
    @IBOutlet weak var control: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let _ = recorderManagement.fileSize()
        
        self.view.addSubview(self.spectrumView)
        

        
    }
    
    lazy var spectrumView: JZYSpectrumView = {
        let view = JZYSpectrumView.init(frame: CGRect.init(x: 100.0, y: 120.0, width: 150.0, height: 60.0))
        view.text = "0"

        view.itemLevelCallback = {
            self.recorderManagement.recorder?.updateMeters()
            let power = self.recorderManagement.recorder?.averagePower(forChannel: 0)
            print("----------power:\(power ?? 0)")
            view.level = power ?? 0
        }
        return view
    }()
    
    @IBAction func recording(_ sender: UIButton) {
        if type{
            recorderManagement.beginRecord()
            type = false
            control.setTitle("录制中...点击结束", for: .normal)
            spectrumView.start()
        }else{
            recorderManagement.stopRecord()
            type = true
            control.setTitle("录音", for: .normal)
            spectrumView.stop()
        }
    }

    @IBAction func play(_ sender: UIButton) {
        recorderManagement.play()
    }
    
    
    @IBAction func go(_ sender: Any) {
//        let vc = TestKit.share.getHomeVC()
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
