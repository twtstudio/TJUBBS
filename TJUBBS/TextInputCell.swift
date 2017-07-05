//
//  TextInputCell.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Marklight

enum TextInputCellType {
    case textField
    case textView
}

class TextInputCell: UITableViewCell {
    
    var titleLabel: UILabel?
    var textField: UITextField?
    var textView: UITextView?
    var type: TextInputCellType = .textField
//    let textStorage = MarklightTextStorage()
    var extendBtn: UIButton?

    convenience init(title: String, placeholder: String, type: TextInputCellType = .textField) {
        self.init()
        if type == .textField {
            textField = UITextField()
            contentView.addSubview(textField!)
            textField?.snp.makeConstraints {
                make in
                make.centerY.equalTo(contentView)
                make.right.equalTo(contentView).offset(-16)
            }
            textField?.placeholder = placeholder
            textField?.textAlignment = .right
            
            titleLabel = UILabel(text: title)
            titleLabel?.font = UIFont.systemFont(ofSize: 17)
            contentView.addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints {
                make in
                make.left.equalTo(contentView).offset(16)
                make.centerY.equalTo(contentView)
                make.right.equalTo(textField!.snp.left).offset(-8)
            }
        } else if type == .textView {
            titleLabel = UILabel(text: title)
            titleLabel?.font = UIFont.systemFont(ofSize: 17)
            titleLabel?.sizeToFit()
            contentView.addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints {
                make in
                make.left.equalTo(contentView).offset(16)
                make.top.equalTo(contentView).offset(10)
            }
            
            textView = UITextView()
//            textStorage.addLayoutManager((textView?.layoutManager)!)
            textView?.font = UIFont.systemFont(ofSize: 17)
            contentView.addSubview(textView!)
            textView?.snp.makeConstraints {
                make in
                make.top.equalTo(titleLabel!.snp.bottom).offset(10)
                make.height.equalTo(120)
                make.right.equalTo(contentView).offset(-16)
                make.left.equalTo(contentView).offset(16)
                make.bottom.equalTo(contentView).offset(-20)
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }
}
