//
//  ProgressView.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    let progressLabel = UILabel(text: "0%", color: .white, fontSize: 13)
    var progress: Double = 0 {
        didSet {
            self.progressLabel.text = "\(Int(progress*100))%"
            self.setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .clear
        self.backgroundColor = .black
        self.alpha = 0.7
        self.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let radius: CGFloat = 18
        let start: CGFloat = -CGFloat(M_PI_2)
        let end: CGFloat = -CGFloat(M_PI_2) + CGFloat.pi*2*CGFloat(progress)

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        ctx?.setLineWidth(5)
        ctx?.setStrokeColor(UIColor.white.cgColor)
        ctx?.addPath(path.cgPath)
        ctx?.strokePath()
    }

}
