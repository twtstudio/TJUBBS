//
//  TextInputCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class TextInputCell: UITableViewCell {
    
    var titleLabel: UILabel?
    var textField: UITextField?

    convenience init(title: String, placeholder: String) {
        self.init()
        
        textField = UITextField()
        contentView.addSubview(textField!)
        textField?.snp.makeConstraints {
            make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        textField?.placeholder = placeholder
        textField?.textAlignment = .right
        
        titleLabel = UILabel(text: title)
        contentView.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints {
            make in
            make.left.equalTo(contentView).offset(16)
            make.centerY.equalTo(contentView)
            make.right.equalTo(textField!.snp.left).offset(-8)
        }
    
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
