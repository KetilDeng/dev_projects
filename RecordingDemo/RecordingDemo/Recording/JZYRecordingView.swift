//
//  JZYRecordingView.swift
//  RecordingDemo
//
//  Created by testuser on 2021/5/12.
//

import UIKit

///状态栏高度
private let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
///安全域高度
private let kSafeHeight: CGFloat = (kStatusBarHeight > 20 ? 34 : 0)

enum JZYRecordingStatus {
    /// 准备录音
    case ready
    /// 正在录音
    case processing
    /// 结束录音
    case end
    /// 播放
    case play
    /// 停止播放
    case stop
}

class JZYRecordingView: UIView {
    /// 录音管理
    let recorderManagement = JZYRecordingManagement()
    /// 回调
    var recordingViewCallback: ((_ tag: Int) -> Void)?
    /// 录音状态
    var status: JZYRecordingStatus = .ready
    /// 录音时长
    var duration: TimeInterval = 0
    /// 当前播放到第几秒
    var playTime: TimeInterval = 0
    /// 播放计时器
    var timer: Timer?
    
    //MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateUI(status: .ready)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        shadeView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit - JZYRecordingView")
    }
    
    //MARK: - UI
    private func setupUI() {
        self.addSubview(self.shadeView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.spectrumView)
        self.contentView.addSubview(self.tipLabel)
        self.contentView.addSubview(self.recordButton)
        self.contentView.addSubview(self.cancelButton)
        self.contentView.addSubview(self.sendButton)
    }
    //MARK: - Event
    /// 按钮点击事件
    @objc private func buttonClick(button: UIButton) {
        if button.tag == 1 {
            if status == .ready {
                status = .processing
                recorderManagement.beginRecord()
                spectrumView.start()
            } else if status == .processing {
                status = .end
                recorderManagement.stopRecord()
                spectrumView.stop()
                updateTotalTime(time: duration)
            } else if status == .end {
                status = .play
                startPlay()
                recorderManagement.play()
            } else if status == .play {
                status = .stop
                stopPlay()
                recorderManagement.stop()
                updateTotalTime(time: duration)
            } else if status == .stop {
                status = .play
                startPlay()
                recorderManagement.play()
            }
            updateUI(status: status)
            
        } else if button.tag == 2 {
            // 取消
            recorderManagement.stop()
            stopPlay()
            tipLabel.text = "点击录音"
            updateUI(status: .ready)
        } else if button.tag == 3 {
            // 发送
            recorderManagement.stop()
            stopPlay()
            dismiss()
        }
    }
    
    //MARK: - Public
    class func show(onView: UIView? = UIApplication.shared.keyWindow) {
        guard let view = onView else {
            print("onView不能为nil")
            return
        }
        let recordingView = JZYRecordingView.init(frame: view.frame)
        view.addSubview(recordingView)
    }
    
    //MARK: - Private
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { (b) in
            self.removeFromSuperview()
        }
    }

    /// 播放刷新时间显示
    @objc private func updateTime() {
        if playTime > duration {
            stopPlay()
        } else {
            updateTotalTime(time: playTime)
            playTime = playTime + 1
        }
    }
    /// 开始播放-计时开始
    private func startPlay() {
        playTime = 0
        let ti = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer = ti
        RunLoop.current.add(ti, forMode: .common)
    }
    /// 停止播放-计时结束
    private func stopPlay() {
        if let ti = timer {
            ti.invalidate()
            timer = nil
            updateTotalTime(time: duration)
            updateUI(status: .end)
        }
    }
    /// 刷新时间显示
    private func updateTotalTime(time: TimeInterval) {
        let min:Int = Int(time/60)
        let sec:Int = Int(time) - min*60
        if sec > 9 {
            tipLabel.text = "\(min):\(sec)"
        } else {
            tipLabel.text = "\(min):0\(sec)"
        }
    }

    /// 根据录音状态刷新UI
    private func updateUI(status: JZYRecordingStatus) {
        self.status = status
        switch status {
        case .ready:
            tipLabel.isHidden = false
            
            spectrumView.isHidden = true
            cancelButton.isHidden = true
            sendButton.isHidden = true
            shadeView.isUserInteractionEnabled = true
            self.recordButton.setBackgroundImage(UIImage(named: "icon_recording_nor"), for: .normal)
        case .processing:
            tipLabel.isHidden = true
            cancelButton.isHidden = true
            sendButton.isHidden = true
            
            spectrumView.isHidden = false
            shadeView.isUserInteractionEnabled = false
            self.recordButton.setBackgroundImage(UIImage(named: "icon_recording_selected"), for: .normal)

        case .end:
            spectrumView.isHidden = true

            tipLabel.isHidden = false
            cancelButton.isHidden = false
            sendButton.isHidden = false
            shadeView.isUserInteractionEnabled = false
            self.recordButton.setBackgroundImage(UIImage(named: "icon_recording_play"), for: .normal)
            
        case .play:
            spectrumView.isHidden = true

            tipLabel.isHidden = false
            cancelButton.isHidden = false
            sendButton.isHidden = false
            shadeView.isUserInteractionEnabled = false
            self.recordButton.setBackgroundImage(UIImage(named: "icon_recording_playing"), for: .normal)
            
        case .stop:
            spectrumView.isHidden = true

            tipLabel.isHidden = false
            cancelButton.isHidden = false
            sendButton.isHidden = false
            shadeView.isUserInteractionEnabled = false
            self.recordButton.setBackgroundImage(UIImage(named: "icon_recording_play"), for: .normal)
        }
    }
    
    //MARK: - Getter
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = CGRect.init(x: 0, y: self.frame.size.height-270, width: self.frame.size.width, height: 270+kSafeHeight)
        return view
    }()
    lazy var shadeView: UIView = {
        let view = UIView()
        view.frame = self.frame
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    lazy var spectrumView: JZYSpectrumView = {
        let view = JZYSpectrumView.init(frame: CGRect.init(x: self.contentView.frame.size.width/2.0-200/2.0, y: 20, width: 200, height: 50.0))

        view.itemLevelCallback = { [weak self] in
            self?.recorderManagement.recorder?.updateMeters()
            //取得第一个通道的音频，音频强度范围是-160到0
            let power = self?.recorderManagement.recorder?.averagePower(forChannel: 0)
            let currentTime = self?.recorderManagement.recorder?.currentTime ?? 0
            view.level = power ?? 0
            self?.duration = currentTime
            view.updateTime(time: currentTime)
            print("----------currentTime:\(currentTime)")
        }
        return view
    }()
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: self.spectrumView.frame.minY, width: self.contentView.frame.size.width, height: self.spectrumView.frame.size.height)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = "点击录音"
        return label
    }()
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: self.contentView.frame.size.width/2-50, y: self.tipLabel.frame.maxY+15, width: 100, height: 100)
        button.setBackgroundImage(UIImage(named: "icon_recording_nor"), for: .normal)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: 15, y: self.recordButton.frame.maxY + 20, width: (self.contentView.frame.size.width-40)/2, height: 40)
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.groupTableViewBackground
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: self.frame.size.width-self.cancelButton.frame.size.width-self.cancelButton.frame.minX, y: self.cancelButton.frame.origin.y, width: self.cancelButton.frame.size.width, height: self.cancelButton.frame.size.height)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        button.tag = 3
        return button
    }()
}
