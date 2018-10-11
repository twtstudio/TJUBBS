//
//  UserCell.swift
//  PiperChat
//
//  Created by Allen X on 5/20/17.
//  Copyright © 2017 allenx. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    var user: UserWrapper!

    convenience init(user: UserWrapper) {
        self.init()
        self.user = user

        let nickName = user.nickname
        let avatarView = UIImageView()

        avatarView.layer.cornerRadius = 28
        avatarView.clipsToBounds = true

        let nameLabel = UILabel(text: nickName!, boldFontSize: 18)
        nameLabel.numberOfLines = 1

        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints {
            make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(14)
            make.height.width.equalTo(56)
        }

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(avatarView.snp.right).offset(14)
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
