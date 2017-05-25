//
//  replyCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit
import Kingfisher

class ReplyCell: UITableViewCell {
    
    let screenSize = UIScreen.main.bounds.size
    var portraitImageView = UIImageView()
    var usernameLable = UILabel(text: "", color: .black)
    var timeLablel = UILabel(text: "", color: .lightGray)
    var detailLabel = UILabel(text: "", color: .lightGray, fontSize: 14)
    var replyNumberLabel = UILabel(text: "", fontSize: 14)
    var floorLabel = UILabel(text: "", fontSize: 14)
    var post: PostModel?
    
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
    
    func initUI(post: PostModel) {
        self.post = post
        
        let portraitImage = UIImage(named: "头像2")
        let url = URL(string: BBSAPI.avatar(uid: post.authorID))
        let cacheKey = "\(post.authorID)" + Date.today
        portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        portraitImageView.snp.makeConstraints {
            make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(120/1920))
        }
        portraitImageView.layer.cornerRadius = screenSize.height*(120/1920)/2
        portraitImageView.clipsToBounds = true
        
        usernameLable.text = post.authorName
        usernameLable.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        let timeString = TimeStampTransfer.string(from: String(post.createTime), with: "HH:mm yyyy-MM-dd")
        timeLablel.text = timeString
        timeLablel.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLable.snp.bottom).offset(4)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        print("clearBBcode: \(String.clearBBCode(string: post.content))")
        detailLabel.text = String.clearBBCode(string: post.content)
        detailLabel.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-8)

        }
        detailLabel.numberOfLines = 0
        
        floorLabel.text = "第 \(post.floor) 楼"
        floorLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(usernameLable)
            make.right.equalToSuperview().offset(-16)
        }
        
        replyNumberLabel.text = "回复(\(post.replyNumber))"
        replyNumberLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(timeLablel)
            make.right.equalToSuperview().offset(-16)
        }
        
//        if let list = subReplyList {
//            for i in 0..<list.count {
//                let subReply = list[i]
//                let subReplyView = SubReplyView(username: subReply["username"]!, time: subReply["time"]!, detail: subReply["detail"]!)
//                contentView.addSubview(subReplyView)
//                subReplyViewList.append(subReplyView)
//                if i == 0 {
//                    subReplyView.snp.makeConstraints {
//                        make in
//                        make.top.equalTo(detailLabel.snp.bottom).offset(8)
//                        make.left.equalTo(portraitImageView.snp.right).offset(8)
//                        make.right.equalToSuperview().offset(-16)
//                    }
//                } else {
//                    subReplyView.snp.makeConstraints {
//                        make in
//                        make.top.equalTo(subReplyViewList[i-1].snp.bottom).offset(8)
//                        make.left.equalTo(portraitImageView.snp.right).offset(8)
//                        make.right.equalToSuperview().offset(-16)
//                    }
//                }
//                if i == list.count-1 {
//                    subReplyView.snp.makeConstraints {
//                        make in
//                        make.bottom.equalToSuperview().offset(-8)
//                    }
//                }
//            }
//        }
    }
}


