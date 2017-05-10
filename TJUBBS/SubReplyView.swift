//
//  SubReplyView.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class SubReplyView: UIView {
    
    var dividerLine: UIView?
    var usernameLabel: UILabel?
    var timeLabel: UILabel?
    var detailLabel: UILabel?
    convenience init(username: String, time: String, detail: String) {
        self.init()
        self.backgroundColor = .white
        
        dividerLine = UIView()
        self.addSubview(dividerLine!)
        dividerLine?.snp.makeConstraints {
            make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        dividerLine?.backgroundColor = .BBSLightGray
        
        usernameLabel = UILabel(text: username, fontSize: 14)
        self.addSubview(usernameLabel!)
        usernameLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(dividerLine!.snp.bottom).offset(8)
            make.left.equalToSuperview()
        }
        
        let timeString = TimeStampTransfer.string(from: time, with: "HH:mm yyyy-MM-dd")
        timeLabel = UILabel(text: timeString, color: .lightGray, fontSize: 14)
        self.addSubview(timeLabel!)
        timeLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(dividerLine!.snp.bottom).offset(8)
            make.right.equalToSuperview()
        }
        
        detailLabel = UILabel(text: detail, color: .lightGray, fontSize: 13)
        self.addSubview(detailLabel!)
        detailLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLabel!.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
        detailLabel?.numberOfLines = 0
    }
}
