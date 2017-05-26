//
//  PostCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher


class PostCell: UITableViewCell {
    
    let screenSize = UIScreen.main.bounds.size
    var portraitImageView = UIImageView()
    var usernameLabel = UILabel(text: "", color: .black, fontSize: 16)
    var favorButton = UIButton(imageName: "收藏")
    var titleLabel = UILabel(text: "", color: .black, fontSize: 20)
    
    var detailLabel = UILabel(text: "", color: .lightGray, fontSize: 14)
    var replyNumberLabel = UILabel(text: "", fontSize: 14)
    var timeLablel = UILabel(text: "", color: .lightGray, fontSize: 16)
    var thread: ThreadModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(favorButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(replyNumberLabel)
        contentView.addSubview(timeLablel)
        favorButton.addTarget { button in
            if let button = button as? UIButton {
                BBSJarvis.collect(threadID: self.thread!.id) {_ in
                    button.setImage(UIImage(named: "已收藏"), for: .normal)
                    button.tag = 1
                }
            }
            // TODO: 取消点赞
//            if let button = button as? UIButton {
//                if button.tag == 1 {
//                    BBSJarvis.deleteCollect(threadID: self.threadID!) {_ in
//                        button.setImage(UIImage(named: "收藏"), for: .normal)
//                        button.tag = 0
//                    }
//                } else {
//                    BBSJarvis.collect(threadID: self.threadID!) {_ in
//                        button.setImage(UIImage(named: "已收藏"), for: .normal)
//                        button.tag = 1
//                    }
//                }
//            }
        }
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
    
    //TODO: init UI with ThreadModel
//    func initUI(portraitImage: UIImage?, username: String, category: String? = nil, favor: Bool = false, title: String, detail: String? = nil, replyNumber: String, time: String, threadID: Int) {
    func initUI(thread: ThreadModel) {
        self.thread = thread
        
        let portraitImage = UIImage(named: "头像2")
        print(BBSAPI.avatar(uid: thread.authorID))
        let url = URL(string: BBSAPI.avatar(uid: thread.authorID))
        let cacheKey = "\(thread.authorID)" + Date.today
        portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        portraitImageView.snp.makeConstraints {
            make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(80/1920))
        }
        portraitImageView.layer.cornerRadius = screenSize.height*(80/1920)/2
        portraitImageView.clipsToBounds = true
        
        usernameLabel.text = thread.authorName
        usernameLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(portraitImageView).offset(2)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        favorButton.setImage(UIImage(named: thread.inCollection ? "已收藏" : "收藏"), for: .normal)
        favorButton.snp.makeConstraints {
            make in
            make.centerY.equalTo(portraitImageView)
            make.right.equalToSuperview()
            make.width.height.equalTo(screenSize.height*(144/1920))
        }
        
        titleLabel.text = thread.title
        // size used to be 20
        titleLabel.font = UIFont.flexibleFont(ofBaseSize: 16.6)
        if thread.category != "" {
            let fooTitle = labeledTitle(label: thread.category, content: thread.title)
            titleLabel.attributedText = fooTitle
        }
        titleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        titleLabel.numberOfLines = 0
        
        if thread.content != "" {
            if detailLabel.superview == nil {
                contentView.addSubview(detailLabel)
            }
            detailLabel.text = String.clearBBCode(string: thread.content)
            detailLabel.snp.makeConstraints {
                make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-24)
            }
        } else {
            if detailLabel.superview != nil {
                detailLabel.removeFromSuperview()
            }
        }
        detailLabel.numberOfLines = 0
        
        replyNumberLabel.text = "回复(\(thread.replyNumber))"
        replyNumberLabel.snp.makeConstraints {
            make in
            if thread.content != "" {
                make.top.equalTo(detailLabel.snp.bottom).offset(16)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
            }
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        let timeString = TimeStampTransfer.string(from: String(thread.createTime), with: "yyyy-MM-dd")
        timeLablel.text = timeString
        timeLablel.snp.makeConstraints {
            make in
            make.centerY.equalTo(replyNumberLabel)
            make.right.equalToSuperview().offset(-16)
        }
    }
}

extension PostCell {
    
    func labeledTitle(label: String, content: String) -> NSMutableAttributedString {
        let fooString = "\(label) \(content)"
        let mutableAttributedString = NSMutableAttributedString(string: fooString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray,range: NSRange(location: 0, length: label.characters.count))
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: label.characters.count+1, length: content.characters.count))
//        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: label.characters.count))
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.flexibleFont(ofBaseSize: 13.3), range: NSRange(location: 0, length: label.characters.count))
//        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSRange(location: label.characters.count+1 , length: content.characters.count))
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.flexibleFont(ofBaseSize: 16.6), range: NSRange(location: label.characters.count+1 , length: content.characters.count))
        
        return mutableAttributedString
    }
}
