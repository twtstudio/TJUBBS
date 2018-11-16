//
//  NewUserDataTableViewCell.swift
//  TJUBBS
//
//  Created by 张毓丹 on 2018/10/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class NewUserDataTableViewCell: UITableViewCell {

    
    var scoreCountLabel = UILabel()
    var threadCountLabel = UILabel()
    var ageCountLabel = UILabel()
    
    
    var scoreLabel = UILabel()
    var threadLabel = UILabel()
    var ageLabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.frame = UIScreen.main.bounds
        
//        loadData(points, threadCount, age)
        setUpLocation()
    }
    
    func setUpLocation(){
        let width = contentView.bounds.width
        // let height = contentView.bounds.height
        
        self.contentView.addSubview(scoreCountLabel)
        self.contentView.addSubview(threadCountLabel)
        self.contentView.addSubview(ageCountLabel)
        
        self.contentView.addSubview(scoreLabel)
        self.contentView.addSubview(threadLabel)
        self.contentView.addSubview(ageLabel)
        
        scoreCountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(15)
            // make.left.equalTo(contentView).offset(20)
            make.width.equalTo(width/3)
            make.height.equalTo(38)
        }
        threadCountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(width/3)
            make.width.equalTo(width/3)
            make.height.equalTo(38)
        }
        ageCountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(width/3*2)
            make.width.equalTo(width/3)
            make.height.equalTo(38)
        }
        
        
        scoreLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(54)
            make.bottom.equalTo(contentView).offset(-9)
            make.left.equalTo(contentView)
            make.width.equalTo(width/3)
        }
        threadLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(54)
            make.bottom.equalTo(contentView).offset(-9)
            
            make.left.equalTo(contentView).offset(width/3)
            make.width.equalTo(width/3)
        }
        ageLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(54)
            make.bottom.equalTo(contentView).offset(-9)
            
            make.left.equalTo(contentView).offset(width/3*2)
            make.width.equalTo(width/3)
        }
        scoreCountLabel.textAlignment = .center
        threadCountLabel.textAlignment = .center
        ageCountLabel.textAlignment = .center
        scoreLabel.textAlignment = .center
        threadLabel.textAlignment = .center
        ageLabel.textAlignment = .center
        
    }
    
    func loadData(points: String, threadCount: String, age: String){
        let countLabelFont = UIFont.systemFont(ofSize: 25)
        scoreCountLabel.text = points
        threadCountLabel.text = threadCount
        ageCountLabel.text = age
        scoreCountLabel.font = countLabelFont
        threadCountLabel.font = countLabelFont
        ageCountLabel.font = countLabelFont
        
        let textLabelFont = UIFont(name:"Helvectic", size: 16)
        
        scoreLabel.text = "积分"
        threadLabel.text = "发帖"
        ageLabel.text = " 站龄"
        scoreLabel.font = textLabelFont
        threadLabel.font = textLabelFont
        ageLabel.font = textLabelFont
    }
    
    
}
