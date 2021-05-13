//
//  JZYSpectrumView.swift
//  RecordingDemo
//
//  Created by testuser on 2021/5/12.
//

import UIKit

class JZYSpectrumView: UIView {
    /// 浪高数组
    var levels: [Float] = []
    /// 频谱条数组
    var itemLineLayers: [CAShapeLayer] = []
    /// self高度
    var itemHeight: CGFloat = 0
    /// self宽度
    var itemWidth: CGFloat = 0
    /// 定时器
    var displayLink: CADisplayLink?
    /// 定时器回调
    var itemLevelCallback: (() -> Void)?
    /// 频谱中间间隙（时间显示的位置）
    var middleInterval:CGFloat = 40
    /// 频谱条宽
    var lineWidth: CGFloat = 2 {
        didSet {
            for itemLine in itemLineLayers {
                itemLine.lineWidth = lineWidth
            }
        }
    }
    /// 频谱条数
    var numberOfItems: UInt = 40 {
        didSet {
            levels = []
            for _ in 0..<numberOfItems/2 {
                levels.append(self.level)
            }
            for itemLine in itemLineLayers {
                itemLine.removeFromSuperlayer()
            }

            itemLineLayers = []
            for _ in 0..<numberOfItems {
                let itemLine = CAShapeLayer()
                itemLine.lineCap       = CAShapeLayerLineCap.butt
                itemLine.lineJoin      = CAShapeLayerLineJoin.round
                itemLine.strokeColor   = UIColor.clear.cgColor
                itemLine.fillColor     = UIColor.clear.cgColor
                itemLine.strokeColor   = itemColor?.cgColor
                itemLine.lineWidth     = lineWidth
                layer.addSublayer(itemLine)
                itemLineLayers.append(itemLine)
            }
        }
    }
    /// 频谱颜色
    var itemColor: UIColor? {
        didSet {
            for itemLine in itemLineLayers {
                itemLine.strokeColor = itemColor?.cgColor
            }
        }
    }
    /// 频谱浪高
    var level:Float = 6 {
        didSet {

            level = (level+37.5)*3.2;
            if level < 0 {
                level = 0
            }
            levels.remove(at: Int(numberOfItems)/2-1)
            levels.insert(level/6.0, at: 0)
            
            updateItems()
        }
    }
    
    // MARK: - Life
    override init(frame: CGRect) {
        super.init(frame: frame)
        itemHeight = frame.height
        itemWidth = frame.width
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit - JZYSpectrumView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemHeight = self.bounds.height
        itemWidth = self.bounds.width
        timeLabel.frame = CGRect.init(x: itemWidth*0.5-middleInterval/2.0, y: 0, width: middleInterval, height: itemHeight)
        lineWidth = (itemWidth-middleInterval)/2.0/CGFloat(numberOfItems)
    }
    
    //MARK: - Public
    // 更新时间
    func updateTime(time: TimeInterval) {
        let min:Int = Int(time/60)
        let sec:Int = Int(time) - min*60
        if sec > 9 {
            timeLabel.text = "\(min):\(sec)"
        } else {
            timeLabel.text = "\(min):0\(sec)"
        }
    }
    // 开始计时
    func start() {
        displayLink = CADisplayLink.init(target: self, selector: #selector(invoke))
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = 10
        } else {
            displayLink?.frameInterval = 10
        }
        displayLink?.add(to: RunLoop.current, forMode: .common)
    }
    // 结束计时
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    //MARK: - Private
    /// 初始化
    private func setup() {
        self.numberOfItems = 40//偶数
        self.itemColor = UIColor.init(red: 241/255, green: 60/255, blue: 57/255, alpha: 1)
        self.middleInterval = 40;
        self.addSubview(self.timeLabel)
    }
    // 更新频谱
    private func updateItems() {
        UIGraphicsBeginImageContext(self.frame.size)
        let lineOffset = lineWidth*2
        var leftX = (self.itemWidth - self.middleInterval + self.lineWidth) / 2.0
        var rightX = (self.itemWidth + self.middleInterval - self.lineWidth) / 2.0
        
        for i in 0..<numberOfItems/2 {
            let lineHeight:CGFloat = lineWidth + CGFloat(levels[Int(i)])*lineWidth/2.0
            let lineTop:CGFloat = (itemHeight - lineHeight)/2.0
            let lineBottom:CGFloat = (itemHeight + lineHeight)/2.0

            leftX = leftX - lineOffset;

            let linePathLeft: UIBezierPath = UIBezierPath()
            linePathLeft.move(to: CGPoint.init(x: leftX, y: lineTop))
            linePathLeft.addLine(to: CGPoint.init(x: leftX, y: lineBottom))
            
            let itemLine2:CAShapeLayer = itemLineLayers[Int(i+numberOfItems/2)]
            itemLine2.path = linePathLeft.cgPath


            rightX = rightX + lineOffset;

            let linePathRight:UIBezierPath = UIBezierPath()
            linePathRight.move(to: CGPoint.init(x: rightX, y: lineTop))
            linePathRight.addLine(to: CGPoint.init(x: rightX, y: lineBottom))
            let itemLine: CAShapeLayer = itemLineLayers[Int(i)]
            itemLine.path = linePathRight.cgPath
        }
        UIGraphicsEndImageContext();
    }
    // 计时器调用
    @objc private func invoke () {
        itemLevelCallback?()
    }

    //MARK: - Getter
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00";
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
