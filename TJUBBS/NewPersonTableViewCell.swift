//
//  NewPersonTableViewCell.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/4/12.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher

class NewPersonTableViewCell: UITableViewCell {
    let screenSize = UIScreen.main.bounds.size
    var thread: ThreadModel?
    var titleLabel: UILabel = UILabel(text: "", color: .black, fontSize: 16)
    var subjectLabel: UILabel = UILabel(text: "", color: .darkGray, fontSize: 14)
    var nameLabel: UILabel = UILabel(text: "", color: .darkGray, fontSize: 14)
    var timeLabel: UILabel = UILabel(text: "", color: .lightGray, fontSize: 14)
    var likedLabel: UILabel = UILabel(text: "", color: .lightGray, fontSize: 14)
    var replyLabel: UILabel = UILabel(text: "", color: .lightGray, fontSize: 14)
    var avatarImageView: UIImageView = UIImageView()
    //var replyImage = UIImageView()
    //(frame: CGRect(x: 0, y: 0, width: 5, height: 5))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.numberOfLines = 1
        subjectLabel.numberOfLines = 5

        contentView.addSubview(nameLabel)
        contentView.addSubview(subjectLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(replyLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(likedLabel)
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

    func loadModel(thread: ThreadModel) {
        self.thread = thread
        let avatarImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: thread.authorID))
        let cacheKey = "\(thread.authorID)" + Date.today

        //avatarImageView
        avatarImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: avatarImage)
        avatarImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(54/1920))
        }
        avatarImageView.layer.cornerRadius = screenSize.height*(54/1920)/2
        avatarImageView.clipsToBounds = true

        //nameLabel
        nameLabel.text = "\(thread.authorName) 发布了帖子"
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
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.left.equalTo(avatarImageView)
//            make.bottom.equalToSuperview().offset(-16)
        }

        //SubjectLabel
        if thread.content != "" {
            if subjectLabel.superview == nil {
                self.contentView.addSubview(subjectLabel)
            }
            subjectLabel.text = String.clearBBCode(string: thread.content)
            subjectLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.left.equalTo(titleLabel)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-40)
            }

            //replyLabel
            replyLabel.text = "回复(\(thread.replyNumber))"
            replyLabel.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.bottom.equalToSuperview().offset(-16)
            }

            //likedLabel
            likedLabel.text = "点赞(\(thread.likeCount))"
            likedLabel.snp.makeConstraints { make in
                make.left.equalTo(replyLabel.snp.right).offset(5)
                make.bottom.equalToSuperview().offset(-16)
            }

            //timeLabel
            let timeStr = TimeStampTransfer.timeLabelSince(time: thread.createTime)
            timeLabel.text = timeStr
            timeLabel.snp.makeConstraints { make in
                make.centerY.equalTo(replyLabel)
                //make.top.equalTo(subjectLabel.snp.bottom).offset(10)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-16)
            }
        } else {
//            if subjectLabel.superview != nil {
//                subjectLabel.removeFromSuperview()
//            }
            subjectLabel.text = " "
            subjectLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.left.equalTo(titleLabel)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-40)
            }
        }

        //replyLabel
        replyLabel.text = "回复(\(thread.replyNumber))"
        replyLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-16)
        }

        //likedLabel
        likedLabel.text = "点赞(\(thread.likeCount))"
        likedLabel.snp.makeConstraints { make in
            make.left.equalTo(replyLabel.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-16)
        }

        //timeLabel
        let timeStr = TimeStampTransfer.timeLabelSince(time: thread.createTime)
        timeLabel.text = timeStr
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(replyLabel)
            //make.top.equalTo(subjectLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
