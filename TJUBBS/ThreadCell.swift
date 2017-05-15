//
//  ThreadCell.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

enum ThreadCellType {
    case single
    case multi
    case none
}

class ThreadCell: UITableViewCell {
    var type: ThreadCellType = .none
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var authorLabel = UILabel()
    var contentLabel = UILabel()
    var imgView: UIImageView?

    convenience init(type: ThreadCellType, title: String, date: String, author: String, content: String) {
        self.init()
        self.type = type
        titleLabel.text = title
        authorLabel.text = author
        contentLabel.text = content
        dateLabel.text = TimeStampTransfer.string(from: date, with: "yyyy-MM-dd")
        titleLabel.sizeToFit()
        authorLabel.sizeToFit()
        dateLabel.sizeToFit()
        contentLabel.sizeToFit()
        contentView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.94, alpha:1.00)
        switch type {
        case .single:
            imgView = UIImageView()
            initSingle()
        case .multi:
            initMulti()
        case .none:
            initNone()
        }
    }
    
    func initSingle() {
        contentView.addSubview(imgView!)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-20)
        }
        
        imgView?.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(60)
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }

        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.textColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        let font = UIFont.systemFont(ofSize: 12)
        contentLabel.font = font
        contentLabel.sizeToFit()
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(imgView!.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(60-dateLabel.frame.height)
        }
        
        authorLabel.font = font
        authorLabel.textColor = UIColor.darkGray
        authorLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
//            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        dateLabel.textColor = UIColor.darkGray
        dateLabel.font = font
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(authorLabel.snp.left).offset(-10)
//            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.bottom.equalTo(imgView!.snp.bottom)
        }
    }
    
    func initMulti() {
    
    }
    
    func initNone() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-20)
        }
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.textColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        let font = UIFont.systemFont(ofSize: 12)
        contentLabel.font = font
        contentLabel.sizeToFit()
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        authorLabel.font = font
        authorLabel.textColor = UIColor.darkGray
        authorLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        dateLabel.textColor = UIColor.darkGray
        dateLabel.font = font
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(authorLabel.snp.left).offset(-10)
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
