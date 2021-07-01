//
//  DKTMarqueeItem.swift
//  DKTMarquee
//
//  Created by testuser on 2021/5/19.
//

import UIKit

class DKTMarqueeItem: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.titleLabel.frame = self.bounds
    }
    func initViews() {
        self.addSubview(titleLabel)
    }
    lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: self.bounds)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}
