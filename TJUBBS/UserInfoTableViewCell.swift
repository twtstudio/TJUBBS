//
//  UserInfoTableViewCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    let screenFrame = UIScreen.main.bounds
    var iconImageView: UIImageView?
    var titleLabel: UILabel?
    var badgeLabel: UILabel?
    var rightArrowImageView: UIImageView?
    
    convenience init(iconName: String, title: String, badgeNumber: Int = 0) {
        self.init()
        
        iconImageView = UIImageView(image: UIImage(named: iconName))
        contentView.addSubview(iconImageView!)
        iconImageView?.snp.makeConstraints {
            make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(screenFrame.height*(57/1920))
        }
        
        titleLabel = UILabel(text: title, fontSize: 18)
        contentView.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints {
            make in
            make.left.equalTo(iconImageView!.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
        
        if badgeNumber != 0 {
            badgeLabel = UILabel.roundLabel(text: "\(badgeNumber)")
            contentView.addSubview(badgeLabel!)
            badgeLabel?.snp.makeConstraints {
                make in
                make.left.equalTo(titleLabel!.snp.right).offset(8)
                make.centerY.equalToSuperview()
            }
        }
        
        rightArrowImageView = UIImageView(image: UIImage(named: "more"))
        contentView.addSubview(rightArrowImageView!)
        rightArrowImageView?.snp.makeConstraints {
            make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(screenFrame.height*(64/1920))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
