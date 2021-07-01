//
//  DKTMarquee.swift
//  DKTMarquee
//
//  Created by testuser on 2021/5/19.
//

import UIKit

class DKTMarquee: UIView {
    
    private var timer: Timer?
    
    private var items: Array<String> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        self.addSubview(scrollView)
    }
    func config(datas: [String]) {
        resetStatus()
        items = datas
        if datas.count > 1 {
            items.append(items[0])
            items.append(items[1])
        }
        configScrollView()
    }
    private func resetStatus() {
        scrollView.setContentOffset(.zero, animated: false)
        scrollView.contentSize = CGSize.zero
    }
    func configScrollView() {
        scrollView.layer.removeAllAnimations()
        let itemH: CGFloat = self.bounds.size.height/2.0
        scrollView.contentSize = CGSize(width: 0, height: CGFloat(items.count)*itemH);
        var tmpY: CGFloat = 0
        for i in 0..<items.count {
            let item = DKTMarqueeItem.init(frame: CGRect.init(x: 0, y: tmpY, width: scrollView.bounds.size.width, height: itemH))
            item.titleLabel.text = items[i]
            scrollView.addSubview(item)
            tmpY += itemH
        }
        startRunning()
    }
    
    func startRunning() {
        stopRunning()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(marqueeRunning), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stopRunning() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func marqueeRunning() {
        let itemH: CGFloat = self.bounds.size.height/2.0
        var point = scrollView.contentOffset
        point.y += itemH
        scrollView.setContentOffset(point, animated: true)
        
        // 延迟执行：主线程
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.scrollView.contentOffset.y >= CGFloat((self.items.count-2))*itemH {
                self.scrollView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
}
