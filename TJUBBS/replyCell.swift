//
//  replyCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit

class ReplyCell: UITableViewCell {
    
    let screenSize = UIScreen.main.bounds.size
    var portraitImageView = UIImageView()
    var usernameLable = UILabel(text: "", color: .black)
    var timeLablel = UILabel(text: "", color: .lightGray)
    var detailLabel = UILabel(text: "", color: .lightGray, fontSize: 14)
    var replyNumberLabel = UILabel(text: "", fontSize: 14)
    var floorLabel = UILabel(text: "", fontSize: 14)
    var subReplyViewList: Array<SubReplyView> = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLable)
        contentView.addSubview(detailLabel)
        contentView.addSubview(replyNumberLabel)
        contentView.addSubview(timeLablel)
        contentView.addSubview(floorLabel)
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
    
    func initUI(portraitImage: UIImage?, username: String, detail: String, floor: String, replyNumber: String, time: String, subReplyList: Array<Dictionary<String, String>>?) {
        
        portraitImageView.image = portraitImage
        portraitImageView.snp.makeConstraints {
            make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(120/1920))
        }
        portraitImageView.layer.cornerRadius = screenSize.height*(120/1920)/2
        portraitImageView.clipsToBounds = true
        
        usernameLable.text = username
        usernameLable.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        let timeString = TimeStampTransfer.string(from: time, with: "HH:mm yyyy-MM-dd")
        timeLablel.text = timeString
        timeLablel.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLable.snp.bottom).offset(4)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        print("detail: \(detail)")
        print("clearBBcode: \(String.clearBBCode(string: detail))")
        detailLabel.text = String.clearBBCode(string: detail)
        detailLabel.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-24)
            if subReplyList == nil || (subReplyList?.count)! == 0 {
                make.bottom.equalToSuperview().offset(-8)
            }
        }
        detailLabel.numberOfLines = 0
        
        floorLabel.text = "第 \(floor) 楼"
        floorLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(usernameLable)
            make.right.equalToSuperview().offset(-16)
        }
        
        replyNumberLabel.text = "回复(\(replyNumber))"
        replyNumberLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(timeLablel)
            make.right.equalToSuperview().offset(-16)
        }
        
        if let list = subReplyList {
            for i in 0..<list.count {
                let subReply = list[i]
                let subReplyView = SubReplyView(username: subReply["username"]!, time: subReply["time"]!, detail: subReply["detail"]!)
                contentView.addSubview(subReplyView)
                subReplyViewList.append(subReplyView)
                if i == 0 {
                    subReplyView.snp.makeConstraints {
                        make in
                        make.top.equalTo(detailLabel.snp.bottom).offset(8)
                        make.left.equalTo(portraitImageView.snp.right).offset(8)
                        make.right.equalToSuperview().offset(-16)
                    }
                } else {
                    subReplyView.snp.makeConstraints {
                        make in
                        make.top.equalTo(subReplyViewList[i-1].snp.bottom).offset(8)
                        make.left.equalTo(portraitImageView.snp.right).offset(8)
                        make.right.equalToSuperview().offset(-16)
                    }
                }
                if i == list.count-1 {
                    subReplyView.snp.makeConstraints {
                        make in
                        make.bottom.equalToSuperview().offset(-8)
                    }
                }
            }
        }
    }
}


