//
//  RanklistTableViewCell.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/11/5.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher

class RanklistTableViewCell: UITableViewCell {

    var avatarImageView = UIImageView()
    var rankLabel = UILabel(text: "", color: .black, fontSize: 24, weight: UIFontWeightRegular)
    var nameLabel = UILabel(text: "", color: .black, fontSize: 18, weight: UIFontWeightRegular)
    var getPointLabel = UILabel(text: "", color: .black, fontSize: 22, weight: UIFontWeightRegular)
    var totalPoint = UILabel(text: "", color: .gray, fontSize: 16, weight: UIFontWeightThin)
    var pointLabel = UILabel(text: "", color: .lightGray, fontSize: 14, weight: UIFontWeightThin)
    var user: UserModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(rankLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(getPointLabel)
        contentView.addSubview(totalPoint)
        contentView.addSubview(pointLabel)
    }
    
    func loadModel(user: UserModel) {
        
        let avatarImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: user.id))
        let cacheKey = "\(user.id)" + Date.today
        
        //avatarImageView
        avatarImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: avatarImage)
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(Variables.WIDTH*(1/8))
            make.left.equalTo(rankLabel.snp.right).offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        avatarImageView.layer.cornerRadius = Variables.WIDTH*(1/8)/2
        avatarImageView.clipsToBounds = true
        
        rankLabel.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(avatarImageView.snp.centerY)
        }
        
        nameLabel.text = "\(user.name)"
        nameLabel.sizeToFit()
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(avatarImageView.snp.right).offset(10)
        }
        
        totalPoint.text = "总积分 \(user.totalPoints)"
        totalPoint.sizeToFit()
        totalPoint.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(avatarImageView.snp.right).offset(10)
        }
        
        getPointLabel.text = "\(user.getPoints)"
        getPointLabel.sizeToFit()
        getPointLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        pointLabel.text = "月积分"
        pointLabel.sizeToFit()
        pointLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(totalPoint.snp.centerY)
            make.centerX.equalTo(getPointLabel.snp.centerX)
            make.bottom.equalToSuperview().offset(-5)
            make.top.equalTo(getPointLabel.snp.bottom).offset(3)
        }
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

}
