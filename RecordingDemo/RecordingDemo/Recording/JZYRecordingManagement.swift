//
//  JZYRecordingManagement.swift
//  TestDemo
//
//  Created by testuser on 2021/5/8.
//

import Foundation
import AVFoundation

class JZYRecordingManagement {
    /// 录音器
    var recorder: AVAudioRecorder?
    /// 播放器
    var player: AVAudioPlayer?
    /// 音频管理器
    var session:AVAudioSession = AVAudioSession.sharedInstance()
    /// 设置保存地址
    var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/record.aac")
    
    //MARK: - Public
    //开始录音
    func beginRecord() {
        //设置session类型
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
                                            AVFormatIDKey: NSNumber(value:kAudioFormatMPEG4AAC),//音频格式
                                            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
                                            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
                                            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
 
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: filePath ?? "")
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorder?.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    /// 结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(filePath ?? "")")
                let _ = fileSize()
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    /// 播放
    func play() {
        //设置外放模式，不然录音会用听筒模式播放，就很小声
        if session.category != AVAudioSession.Category.playback {
            do {
                try session.setCategory(AVAudioSession.Category.playback)
            } catch {
                print("外放模式设置失败")
            }
        }
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath ?? ""))
            print("音频时长：\(player?.duration ?? 0)")
            player?.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    /// 停止播放
    func stop() {
        if let palyerValue = player {
            if palyerValue.isPlaying {
                palyerValue.stop()
            }
        }
    }
    
    /// 计算文件大小
    func fileSize() -> UInt64 {
        var fileSize : UInt64 = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath ?? "")
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            print("文件大小：\(Double(fileSize)/1024.0/1024.0) M")
        } catch let err {
            print("文件大小Error: \(err)")
        }
        return fileSize
    }
}
