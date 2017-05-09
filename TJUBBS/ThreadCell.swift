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
        dateLabel.text = date
        titleLabel.sizeToFit()
        authorLabel.sizeToFit()
        dateLabel.sizeToFit()
        contentLabel.sizeToFit()
        contentView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        initUI(type: type)
    }
    
    func bind(with model: ThreadModel) {
        
    }

    func initUI(type: ThreadCellType) {
        switch type {
        case .single:
            initSingle()
        case .multi:
            initMulti()
        case .none:
            initNone()
        }
    }
    
    func initSingle() {
        imgView = UIImageView()
        contentView.addSubview(imgView!)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-20)
        }
        
        imgView?.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        contentLabel.numberOfLines = 4
        contentLabel.sizeToFit()
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(imgView!.snp.right).offset(5)
            make.left.equalTo(contentView).offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(contentLabel.snp.bottom).offset(-3)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(authorLabel.snp.left).offset(-5)
            make.bottom.equalTo(contentView).offset(-5)
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
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-20)
        }
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.textColor = UIColor(red:0.24, green:0.25, blue:0.25, alpha:1.00)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.sizeToFit()
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        authorLabel.font = UIFont.systemFont(ofSize: 14)
        authorLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(contentLabel.snp.bottom).offset(-10)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.snp.makeConstraints { make in
            make.right.equalTo(authorLabel.snp.left).offset(-5)
            make.top.equalTo(contentLabel.snp.bottom).offset(-10)
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
