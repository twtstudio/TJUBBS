//
//  HotThreadTableViewCell.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/10/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher

class HotThreadTableViewCell: UITableViewCell {

    let screenSize = UIScreen.main.bounds.size
    var thread: ThreadModel?
    var titleLabel: UILabel = UILabel(text: "", color: .black, fontSize: 21, weight: UIFontWeightLight)
    var nameLabel: UILabel = UILabel(text: "", color: .darkGray, fontSize: 16, weight: UIFontWeightLight)
    var timeLabel: UILabel = UILabel(text: "", color: .darkGray, fontSize: 13, weight: UIFontWeightLight)
    var likedLabel: UILabel = UILabel(text: "", color: .darkGray, fontSize: 14, weight: UIFontWeightLight)
    var replyLabel: UILabel = UILabel(text: "", color: .darkGray, fontSize: 14, weight: UIFontWeightLight)
    var contentLabel: UILabel = UILabel(text: "", color: UIColor.gray, fontSize: 14, weight: UIFontWeightLight)
    var avatarImageView: UIImageView = UIImageView()
    
    var likeImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var replyImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var boardButton = ExtendedButton(title: "", color: UIColor(hex6: 0x1e88e5), fontSize: 14, isConfirmButton: false)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(replyLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(likedLabel)
        contentView.addSubview(boardButton)
        contentView.addSubview(likeImageView)
        contentView.addSubview(replyImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadModel(thread: ThreadModel) {
        self.thread = thread
        let avatarImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: thread.authorID))
        let cacheKey = "\(thread.authorID)" + Date.today
        
        //avatarImageView
        avatarImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: avatarImage)
        avatarImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(64/1920))
        }
        avatarImageView.layer.cornerRadius = screenSize.height*(64/1920)/2
        avatarImageView.clipsToBounds = true
        
        //nameLabel
        nameLabel.text = "\(thread.authorName)"
        nameLabel.sizeToFit()
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp.right).offset(7)
        }
        
        //TitleLabel
        titleLabel.text = thread.title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.flexibleFont(ofBaseSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(avatarImageView)
        }
        
        //ContentLabel
        contentLabel.text = thread.content
        contentLabel.numberOfLines = 5
        contentLabel.font = UIFont.flexibleFont(ofBaseSize: 12)
        contentLabel.snp.makeConstraints {make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(replyLabel.snp.top).offset(-10)
            make.right.equalToSuperview().offset(-16)
        }
        
        //replyImageView
        replyImageView.image = UIImage(named: "评论")
        replyImageView.snp.makeConstraints { make in
//            make.top.equalTo(content.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-6)
            make.left.equalTo(titleLabel)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        //replyLabel
        replyLabel.text = "\(thread.replyNumber)"
        replyLabel.snp.makeConstraints { make in
            make.left.equalTo(replyImageView.snp.right)
            //            make.bottom.equalToSuperview().offset(-12)
            make.centerY.equalTo(replyImageView.snp.centerY)
        }
        
        //likeImageView
        likeImageView.image = UIImage(named: "点赞")
        likeImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.left.equalTo(replyLabel.snp.right).offset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        //likedLabel
        likedLabel.text = "\(thread.likeCount)"
        likedLabel.snp.makeConstraints { make in
            make.left.equalTo(likeImageView.snp.right)
            //            make.bottom.equalToSuperview().offset(-12)
            make.centerY.equalTo(likeImageView.snp.centerY)
        }
        
        //timeLabel
        let timeStr = TimeStampTransfer.timeLabelSinceNewly(time: thread.createTime)
        timeLabel.text = timeStr
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(replyLabel)
            //make.top.equalTo(subjectLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        //boardButton
        boardButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-15)
        }
        boardButton.setTitle("\(thread.boardName)", for: .normal)
    }
}
