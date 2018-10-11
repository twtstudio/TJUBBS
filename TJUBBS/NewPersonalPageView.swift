//
//  NewPersonalPageView.swift
//  TJUBBS
//
//  Created by HouQinhan on 2018/3/2.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class NewPersonalPageView: UIView {
    let avatarViewBackground = UIImageView()
    let blackGlassView = UIView()
    let avatarView = UIImageView()
    let usernameLabel = UILabel(text: "", color: .white, fontSize: 20)
    let signatureLabel = UILabel(text: "", color: .white, fontSize: 16)
    let scoreLabel = UILabel(text: "", color: .black, fontSize: 26, weight: UIFontWeightLight)
    let threadCountLabel = UILabel(text: "", color: .black, fontSize: 26, weight: UIFontWeightLight)
    let ageLabel = UILabel(text: "", color: .black, fontSize: 26, weight: UIFontWeightLight)
    let activityTabelView = UITableView(frame: .zero, style: .plain)

    var messageImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let messageButton = UIButton()

    var friendImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let friendButton = UIButton()

    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width

    var flexOffset: Int {
        get {
            let screenWidth = UIScreen.main.bounds.width
            if screenWidth <= 320 {
                return -4
            } else if screenWidth >= 414 {
                return -8
            } else {
                return -8
            }
        }
    }

    var flexButtonSize: Int {
        get {
            let screenWidth = UIScreen.main.bounds.width
            if screenWidth <= 320 {
                return 45
            } else if screenWidth >= 414 {
                return 60
            } else if screenWidth == 375 {
                return 50
            } else {
                return 60
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(avatarViewBackground)
        self.addSubview(blackGlassView)
        self.addSubview(avatarView)
        self.addSubview(usernameLabel)
        self.addSubview(signatureLabel)
        self.addSubview(scoreLabel)
        self.addSubview(threadCountLabel)

        self.addSubview(messageImageView)
        self.addSubview(messageButton)
        self.addSubview(friendImageView)
        self.addSubview(friendButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let avatarHeight: CGFloat = 140
        blackGlassView.backgroundColor = .black
        blackGlassView.alpha = 0.80
//        avatarViewBackground.alpha = 0.80

        blackGlassView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-screenHeight * 0.12)
        }

        avatarViewBackground.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-screenHeight * 0.12)
        }

        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = avatarHeight/2
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.masksToBounds = true

        avatarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(screenHeight * 0.15)
            make.height.width.equalTo(avatarHeight)
        }

        usernameLabel.numberOfLines = 1
        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalToSuperview().offset(screenHeight * 0.440)
            make.height.equalTo(21.5)
        }

        signatureLabel.numberOfLines = 1
        signatureLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        signatureLabel.snp.makeConstraints { make in

            make.right.equalToSuperview().offset(-200)
            make.left.equalTo(usernameLabel.snp.left)
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.height.equalTo(19.5)
        }

        let baseWidth = rect.size.width/6

        let scoreHintLabel = UILabel(text: "积分", color: .gray, fontSize: 14)
        scoreHintLabel.font = UIFont.HHflexibleFont(ofBaseSize: 12)
        self.addSubview(scoreHintLabel)
        scoreHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(1*baseWidth)
            make.bottom.equalToSuperview().offset(flexOffset)
        }
        scoreLabel.font = UIFont.HHflexibleFont(ofBaseSize: 25)
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(1*baseWidth)
            //make.top.equalTo(signatureLabel.snp.bottom).offset(screenHeight * 0.065)
            make.height.equalTo(24)
            make.bottom.equalTo(scoreHintLabel.snp.top).offset(-5)

        }

        let threadHintLabel = UILabel(text: "帖子", color: .gray, fontSize: 14)
        threadHintLabel.font = UIFont.HHflexibleFont(ofBaseSize: 12)
        self.addSubview(threadHintLabel)
        threadHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(3*baseWidth)
            make.bottom.equalToSuperview().offset(flexOffset)

        }
        threadCountLabel.font = UIFont.HHflexibleFont(ofBaseSize: 25)
        threadCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(3*baseWidth)
            //make.top.equalTo(signatureLabel.snp.bottom).offset(screenHeight * 0.065)
            make.height.equalTo(24)
            make.bottom.equalTo(threadHintLabel.snp.top).offset(-5)
        }

        let ageHintLabel = UILabel(text: "站龄", color: .gray, fontSize: 14)
        ageHintLabel.font = UIFont.HHflexibleFont(ofBaseSize: 12)
        //ageHintLabel.font = UIFont.flexibleFont(ofBaseSize: 12.8)
        self.addSubview(ageHintLabel)
        ageHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(5*baseWidth)
            //make.top.equalTo(ageLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(flexOffset)
            //make.height.equalTo(17)
        }
        ageLabel.font = UIFont.HHflexibleFont(ofBaseSize: 25)
        self.addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(5*baseWidth)
            //make.top.equalTo(signatureLabel.snp.bottom).offset(screenHeight * 0.065)
            make.bottom.equalTo(ageHintLabel.snp.top).offset(-5)
            make.height.equalTo(24)
        }

        messageImageView.image = UIImage(named: "私信")?.kf.resize(to: CGSize(width: flexButtonSize, height: flexButtonSize))
        messageImageView.contentMode = .center
        messageImageView.snp.makeConstraints {make in
            make.centerX.equalTo(ageHintLabel)
            make.centerY.equalTo(avatarViewBackground.snp.bottom)
        }
        messageButton.frame = CGRect(x: 0, y: 0, width: flexButtonSize, height: flexButtonSize)
        messageButton.snp.makeConstraints {make in
            make.centerX.equalTo(ageHintLabel)
            make.centerY.equalTo(avatarViewBackground.snp.bottom)
        }

        friendImageView.image = UIImage(named: "加好友")?.kf.resize(to: CGSize(width: flexButtonSize, height: flexButtonSize))
        friendImageView.contentMode = .center
        friendImageView.snp.makeConstraints {make in
            make.centerX.equalTo(ageHintLabel).offset(-flexButtonSize-10)
            make.centerY.equalTo(avatarViewBackground.snp.bottom)
        }
        friendButton.frame = CGRect(x: 0, y: 0, width: flexButtonSize, height: flexButtonSize)
        friendButton.snp.makeConstraints {make in
            make.centerX.equalTo(ageHintLabel).offset(-flexButtonSize-10)
            make.centerY.equalTo(avatarViewBackground.snp.bottom)
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
