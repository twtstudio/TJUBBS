//
//  NewUserInfoTableViewCell.swift
//  TJUBBS
//
//  Created by 张毓丹 on 2018/10/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class NewUserInfoTableViewCell: UITableViewCell {

    var avatarView = UIImageView(frame: CGRect(origin:.zero, size: CGSize(width: 70, height: 70)))
    var nameLabel = UILabel()
    var gradeLabel = UILabel()
    var signatureLabel = UILabel()

    // 个人主页label
    var personalPageLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 65, height: 20)))
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(avatarImageView: UIImageView, userName: String, signature: String, grade: String) {
       
        avatarView = avatarImageView

        let avatarHeight: CGFloat = 70
        avatarView.layer.cornerRadius = avatarHeight/2 + 4
        avatarView.layer.borderWidth = 1
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.masksToBounds = true
        
        self.accessoryType = .disclosureIndicator
        self.contentView.frame = UIScreen.main.bounds
        
        self.personalPageLabel.text = "个人主页"
        personalPageLabel.textAlignment = .right
        personalPageLabel.textColor = .darkGray
        personalPageLabel.font = UIFont.systemFont(ofSize: 17)
        self.contentView.addSubview(personalPageLabel)
           self.contentView.addSubview(avatarView)
       
        self.nameLabel.text = userName
        self.gradeLabel.text = grade
        self.signatureLabel.text = signature
        initLayout()
      
    }
    
    func loadData( name: String, grade: String, signature:String) {
    
        self.nameLabel.text = name
        self.gradeLabel.text = grade
        self.signatureLabel.text = signature
        
    }
    func initLayout() {
        
        self.contentView.addSubview(nameLabel)
//        self.contentView.addSubview(gradeLabel)
        self.contentView.addSubview(signatureLabel)
        
        
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).offset(-15)
            make.width.equalTo(80)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(30)
            make.left.equalTo(avatarView.snp.right).offset(10)
            make.width.equalTo(130)
            make.height.equalTo(36)
        }
//        gradeLabel.snp.makeConstraints { make in
//            make.top.equalTo(nameLabel).offset(35)
//            make.left.equalTo(nameLabel)
//            make.width.equalTo(130)
//            make.height.equalTo(21)
//        }
        signatureLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel).offset(34)
            make.left.equalTo(nameLabel)
            make.width.equalTo(150)
            make.height.equalTo(21)
        }
        personalPageLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        nameLabel.textAlignment = .left
        
        gradeLabel.textColor = .darkGray
        signatureLabel.textColor = .darkGray
        gradeLabel.textAlignment = .left
        signatureLabel.textAlignment = .left
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension UIImage {
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
}
