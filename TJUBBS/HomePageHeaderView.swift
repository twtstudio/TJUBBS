//
//  HomePageHeaderView.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/6/7.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import FSPagerView

class HomePageHeaderView: UIView {
    let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15 - 10))
    
    let announceLabel = UILabel(text: "公告", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)
    let activityLabel = UILabel(text: "活动", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)
    let eliteLabel = UILabel(text: "十大", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)
    let rankLabel = UILabel(text: "排行", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)

    let announceButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let activityButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let eliteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let rankButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    let baseWidth = UIScreen.main.bounds.width / 8
    let buttonSize = 35
    let bottomHeight = -25
    let topHeight = 5


    override init(frame: CGRect) {
        super.init(frame: frame)
        container.backgroundColor = UIColor.white
        self.addSubview(container)

        container.addSubview(announceButton)
        container.addSubview(activityButton)
        container.addSubview(eliteButton)
        container.addSubview(rankButton)
        container.addSubview(announceLabel)
        container.addSubview(activityLabel)
        container.addSubview(eliteLabel)
        container.addSubview(rankLabel)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let annonceBtnImage = UIImage(named: "公告")
        announceButton.setBackgroundImage(annonceBtnImage, for: .normal)
        announceButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth)
            make.centerY.equalToSuperview()
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        let activityBtnImage = UIImage(named: "活动")
        activityButton.setBackgroundImage(activityBtnImage, for: .normal)
        activityButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth * 3)
            make.centerY.equalToSuperview()
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        let eliteBtnImage = UIImage(named: "十大")
        eliteButton.setBackgroundImage(eliteBtnImage, for: .normal)
        eliteButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth * 5)
            make.centerY.equalToSuperview()
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        let rankBtnImage = UIImage(named: "排行")
        rankButton.setBackgroundImage(rankBtnImage, for: .normal)
        rankButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth * 7)
            make.centerY.equalToSuperview()
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        rankLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rankButton)
            make.top.equalTo(rankButton.snp.bottom).offset(topHeight)
        }

        announceLabel.snp.makeConstraints { make in
            make.centerX.equalTo(announceButton)
            make.top.equalTo(announceButton.snp.bottom).offset(topHeight)
        }

        activityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(activityButton)
            make.top.equalTo(activityButton.snp.bottom).offset(topHeight)
        }

        eliteLabel.snp.makeConstraints { make in
            make.centerX.equalTo(eliteButton)
            make.top.equalTo(eliteButton.snp.bottom).offset(topHeight)
        }
    }
}
