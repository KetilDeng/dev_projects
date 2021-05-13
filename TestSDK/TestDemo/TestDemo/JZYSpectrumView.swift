//
//  JZYSpectrumView.swift
//  GYSpectrum
//
//  Created by testuser on 2021/5/11.
//  Copyright © 2021 黄国裕. All rights reserved.
//

import UIKit

class JZYSpectrumView: UIView {
    var levels:[Float] = []
    var itemLineLayers:[CAShapeLayer] = []
    var itemHeight:CGFloat = 0
    var itemWidth:CGFloat = 0
    var lineWidth:CGFloat = 0 {
        didSet {
            for itemLine in itemLineLayers {
                itemLine.lineWidth = lineWidth
            }
        }
    }
    var displayLink: CADisplayLink?
    var itemLevelCallback:(() -> Void)?
//    {
//        didSet {
//            start()
//        }
//    }
    var numberOfItems:UInt = 0 {

        willSet {
            
        }
        
        didSet {

            levels = []
            for _ in 0..<numberOfItems/2 {
                levels.append(0)
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
    var itemColor:UIColor? {
        didSet {
            for itemLine in itemLineLayers {
                itemLine.strokeColor = itemColor?.cgColor
            }
        }
    }
    var level:Float = 0 {
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
    var text = "" {
        didSet {
            timeLabel.text = text;
        }
    }
    var middleInterval:CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }



    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemHeight = self.bounds.height
        itemWidth = self.bounds.width
        timeLabel.sizeToFit()
        timeLabel.center = CGPoint.init(x: itemWidth*0.5, y: itemHeight*0.5)
        lineWidth = (itemWidth-middleInterval)/2/CGFloat(numberOfItems)
    }
    
    func setup() {
        self.numberOfItems = 20//偶数

        self.itemColor = UIColor.init(red: 241/255, green: 60/255, blue: 57/255, alpha: 1)

        self.middleInterval = 30;

        self.addSubview(self.timeLabel)
    }
    
    func updateItems() {
        UIGraphicsBeginImageContext(self.frame.size)
        let lineOffset = lineWidth*2
        var leftX = (self.itemWidth - self.middleInterval + self.lineWidth) / 2.0
        var rightX = (self.itemWidth + self.middleInterval - self.lineWidth) / 2.0
        
        for i in 0..<numberOfItems/2 {
            let lineHeight:CGFloat = lineWidth + CGFloat(levels[Int(i)])*lineWidth/2.0
            //([[self.levels objectAtIndex:i]intValue]+1)*self.lineWidth/2.f;
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

    
    func start() {
        displayLink = CADisplayLink.init(target: self, selector: #selector(invoke))
        if #available(iOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = 6
        } else {
            displayLink?.frameInterval = 6
        }
        displayLink?.add(to: RunLoop.current, forMode: .common)
    }
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc func invoke () {
        itemLevelCallback?()
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "";
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()

}
