//
//  MessageCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var screenSize = UIScreen.main.bounds.size
    var portraitImageView = UIImageView()
    var usernameLabel = UILabel(text: "", fontSize: 18)
    var timeLabel = UILabel(text: "", color: .lightGray, fontSize: 16)
    var detailLabel = UILabel(text: "", color: .lightGray, fontSize: 16)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(detailLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initUI(portraitImage: UIImage?, username: String, time: String, detail: String) {
        
        portraitImageView.image = portraitImage
        portraitImageView.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.height.equalTo(44)
//            make.width.height.equalTo(screenSize.width*(160/1080))
            make.left.equalToSuperview().offset(16)
        }
        
//        portraitImageView.layer.cornerRadius = screenSize.width*(160/1080)/2
        portraitImageView.layer.cornerRadius = 44/2
        portraitImageView.clipsToBounds = true
        
        usernameLabel.text = username
        usernameLabel.sizeToFit()
        usernameLabel.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView.snp.top)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        let timeString = TimeStampTransfer.string(from: time, with: "MM-dd")
        timeLabel.text = timeString
        timeLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(usernameLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        detailLabel.text = detail
        detailLabel.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
//            make.bottom.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
}
