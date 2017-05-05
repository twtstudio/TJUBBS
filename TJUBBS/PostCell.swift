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
    var portraitImageView: UIImageView?
    var usernameLable: UILabel?
    var favorButton: UIButton?
    var categoryLabel: UILabel?
    var titleLable: UILabel?
    var detailLabel: UILabel?
    var replyNumberLabel: UILabel?
    var timeLablel: UILabel?
    
    convenience init(portraitImage: UIImage, username: String, category: String? = nil, favor: Bool = false, title: String, detailText: String? = nil, replyNumber: Int, time: Int) {
        self.init()
        portraitImageView = UIImageView(image: portraitImage)
        contentView.addSubview(portraitImageView!)
        portraitImageView?.snp.makeConstraints {
            make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenFrame.height*(80/1920))
        }
        portraitImageView?.layer.cornerRadius = screenFrame.height*(80/1920)/2
        portraitImageView?.clipsToBounds = true
        
        usernameLable = UILabel(text: username, fontSize: 18)
        contentView.addSubview(usernameLable!)
        usernameLable?.snp.makeConstraints {
            make in
            make.centerY.equalTo(portraitImageView!).offset(4)
            make.left.equalTo(portraitImageView!.snp.right).offset(8)
        }
        
        favorButton = UIButton()
        contentView.addSubview(favorButton!)
        favorButton?.snp.makeConstraints {
            make in
            make.centerY.equalTo(portraitImageView!)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(screenFrame.height*(48/1920))
        }
        
        titleLable = UILabel()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
