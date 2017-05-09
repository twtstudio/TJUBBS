//
//  PostCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    let screenFrame = UIScreen.main.bounds
    var portraitImageView = UIImageView()
    var usernameLable = UILabel(text: "", color: .black, fontSize: 18)
    var favorButton = UIButton(imageName: "收藏")
    var titleLable = UILabel(text: "", fontSize: 20)
    var detailLabel = UILabel(text: "", color: .lightGray, fontSize: 14)
    var replyNumberLabel = UILabel(text: "", fontSize: 14)
    var timeLablel = UILabel(text: "", color: .lightGray, fontSize: 16)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLable)
        contentView.addSubview(favorButton)
        contentView.addSubview(titleLable)
        contentView.addSubview(detailLabel)
        contentView.addSubview(replyNumberLabel)
        contentView.addSubview(timeLablel)
        favorButton.addTarget { button in
            print("clicked")
            button.setImage(UIImage(named: "已收藏"), for: .normal)
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
    
    func initUI(portraitImage: UIImage?, username: String, category: String? = nil, favor: Bool = false, title: String, detail: String? = nil, replyNumber: String, time: String) {
        
        portraitImageView.image = portraitImage
        portraitImageView.snp.makeConstraints {
            make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenFrame.height*(80/1920))
        }
        portraitImageView.layer.cornerRadius = screenFrame.height*(80/1920)/2
        portraitImageView.clipsToBounds = true
        
        usernameLable.text = username
        usernameLable.snp.makeConstraints {
            make in
            make.centerY.equalTo(portraitImageView).offset(2)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        favorButton.snp.makeConstraints {
            make in
            make.centerY.equalTo(portraitImageView)
            make.right.equalToSuperview()
            make.width.height.equalTo(screenFrame.height*(144/1920))
        }
        
        titleLable.text = title
        if let label = category {
            let fooTitle = labeledTitle(label: label, content: title)
            titleLable.attributedText = fooTitle
        }
        titleLable.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        titleLable.numberOfLines = 0
        
        if let text = detail {
            if detailLabel.superview == nil {
                contentView.addSubview(detailLabel)
            }
            detailLabel.text = text
            detailLabel.snp.makeConstraints {
                make in
                make.top.equalTo(titleLable.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-24)
            }
        } else {
            if detailLabel.superview != nil {
                detailLabel.removeFromSuperview()
            }
        }
        detailLabel.numberOfLines = 0
        
        replyNumberLabel.text = "回复(\(replyNumber))"
        replyNumberLabel.snp.makeConstraints {
            make in
            if let _ = detail {
                make.top.equalTo(detailLabel.snp.bottom).offset(16)
            } else {
                make.top.equalTo(titleLable.snp.bottom).offset(16)
            }
            make.left.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        let timeString = TimeStampTransfer.string(from: time, with: "yyyy-MM-dd")
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
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: label.characters.count))
        mutableAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20), range: NSRange(location: label.characters.count+1 , length: content.characters.count))
        
        return mutableAttributedString
    }
}
