//
//  UserInfoTableViewCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    var iconImageView: UIImageView?
    var titleLabel: UILabel?
    var badgeLabel: UILabel?
    
    convenience init(iconName: String, title: String, badgeNumber: Int = 0) {
        self.init()
        self.accessoryType = .disclosureIndicator
        
        iconImageView = UIImageView(image: UIImage(named: iconName))
        contentView.addSubview(iconImageView!)
        iconImageView?.snp.makeConstraints {
            make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.bounds.width*(57/1080))
        }
        
//        titleLabel = UILabel(text: title, fontSize: 18)
        titleLabel = UILabel(text: title)
        titleLabel?.font = UIFont.flexibleFont(ofBaseSize: 15)
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
