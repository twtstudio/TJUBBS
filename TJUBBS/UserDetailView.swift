//
//  UserDetailView.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class UserDetailView: UIView {
    let avatarViewBackground = UIImageView()
    let avatarView = UIImageView()
    let frostView = UIVisualEffectView()
    let usernameLabel = UILabel(text: "", color: .white, fontSize: 18)
    let signatureLabel = UILabel(text: "", color: .white, fontSize: 16)
    let scoreLabel = UILabel(text: "", color: .white, fontSize: 20)
    let threadCountLabel = UILabel(text: "", color: .white, fontSize: 20)
    let ageLabel = UILabel(text: "", color: .white, fontSize: 20)
    let tableView = UITableView(frame: .zero, style: .grouped)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatarViewBackground)
        self.addSubview(frostView)
        self.addSubview(avatarView)
        self.addSubview(usernameLabel)
        self.addSubview(signatureLabel)
        self.addSubview(scoreLabel)
        self.addSubview(threadCountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        avatarViewBackground.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        frostView.effect = UIBlurEffect(style: .dark)
        frostView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(avatarViewBackground)
        }
        
        let avatarHeight: CGFloat = 80
        avatarView.layer.cornerRadius = avatarHeight/2
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.masksToBounds = true
        
        avatarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(64)
            make.height.width.equalTo(avatarHeight)
        }
        
        usernameLabel.numberOfLines = 1
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(10)
            make.height.equalTo(21.5)
        }
        
        signatureLabel.numberOfLines = 1
        signatureLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        signatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.right.equalToSuperview().offset(-100)
            
           make.left.equalToSuperview().offset(100)
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.height.equalTo(19.5)
        }
        
        let baseWidth = rect.size.width/6
        
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(1*baseWidth)
            make.top.equalTo(signatureLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        let scoreHintLabel = UILabel(text: "积分", color: .white, fontSize: 14)
        self.addSubview(scoreHintLabel)
        scoreHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(1*baseWidth)
            make.top.equalTo(scoreLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        threadCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(3*baseWidth)
            make.top.equalTo(signatureLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        let threadHintLabel = UILabel(text: "发帖", color: .white, fontSize: 14)
        self.addSubview(threadHintLabel)
        threadHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(3*baseWidth)
            make.top.equalTo(threadCountLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(5*baseWidth)
            make.top.equalTo(signatureLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        let ageHintLabel = UILabel(text: "站龄", color: .white, fontSize: 14)
        self.addSubview(ageHintLabel)
        ageHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(5*baseWidth)
            make.top.equalTo(ageLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().offset(-10)
        }
        let dayLabel = UILabel(text: "天", color: .white, fontSize: 8)
        self.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(ageLabel.snp.bottom)
            make.left.equalTo(ageLabel.snp.right)
        }
        
        let divider1 = UIView()
        divider1.backgroundColor = .white
        let divider2 = UIView()
        divider2.backgroundColor = .white
        
        self.addSubview(divider1)
        divider1.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.top)
            make.bottom.equalTo(scoreHintLabel.snp.bottom)
            make.width.equalTo(1)
            make.left.equalTo(2*baseWidth)
        }
        self.addSubview(divider2)
        divider2.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.top)
            make.bottom.equalTo(scoreHintLabel.snp.bottom)
            make.width.equalTo(1)
            make.left.equalTo(4*baseWidth)
        }
        self.sizeToFit()
    }

    func loadModel(user: UserWrapper) {
        usernameLabel.text = user.username
        signatureLabel.text = user.signature
        scoreLabel.text = "\(user.points ?? 0)"
        threadCountLabel.text = "\((user.postCount ?? 0) + (user.threadCount ?? 0))"
        if let tCreate = user.tCreate {
            ageLabel.text = "\(TimeStampTransfer.daysSince(time: tCreate))"
        } else {
            ageLabel.text = "0"
        }
    }
}
