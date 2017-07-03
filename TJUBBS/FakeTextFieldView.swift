//
//  FakeTextFieldView.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class FakeTextFieldView: UIView {
    let textFieldView = UIView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .white
        textFieldView.backgroundColor = UIColor(red:0.90, green:0.93, blue:0.94, alpha:1.00)
        textFieldView.frame = CGRect(x: 4, y: 6, width: Int(rect.size.width-8), height: Int(rect.size.height-12))
        textFieldView.layer.cornerRadius = (rect.size.height-6)/2
        self.addSubview(textFieldView)
        let label = UILabel(text: "发表回复", color: UIColor(red:0.51, green:0.57, blue:0.62, alpha:1.00), fontSize: 17)
        label.sizeToFit()
        label.y = (textFieldView.frame.size.height - label.height)/2
        label.x = 20
        textFieldView.addSubview(label)
    }
}
