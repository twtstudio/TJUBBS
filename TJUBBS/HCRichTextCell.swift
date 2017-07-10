//
//  HCRichTextCell.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import YYText
import DTCoreText
import Kingfisher

class HCRichTextCell: UITableViewCell {
    let portraitImageView = UIImageView(image: UIImage(named: "default"))
    let usernameLabel = UILabel(text: "")
    let nickNameLabel = UILabel(text: "", color: .gray)
    let timeLabel = UILabel(text: "HH:mm yyyy-MM-dd", color: .lightGray, fontSize: 14)
    let moreButton = ExtendedButton()
    //    let contentLabel = YYLabel()
    let postLabel: YYLabel = {
        let postLabel = YYLabel()
        postLabel.displaysAsynchronously = true
        postLabel.numberOfLines = 0
        return postLabel
    }()
    
    var delegate: ImageSizeChangeDelegate?
    
    /// 装上面定义的那些元素的容器
    var contentPanel: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(contentPanel)
        contentPanel.addSubview(portraitImageView)
        contentPanel.addSubview(usernameLabel)
        contentPanel.addSubview(postLabel)
        
        contentPanel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        portraitImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.width.height.equalTo(44)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(portraitImageView.snp.top)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        postLabel.snp.makeConstraints { make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(10)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(contentPanel).offset(-10)
        }
        
        contentPanel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    func bind(_ model: PostModel, layout: YYTextLayout) {
//        var backupString = NSMutableAttributedString(attributedString: layout.text)
//        var shouldUpdate = false
//        layout.text.enumerateAttributes(in: NSMakeRange(0, layout.text.length), options: .reverse, using: { (attributes, range, stop) in
//            if let attachment = attributes["NSAttachment"] as? DTImageTextAttachment {
//                let imageView = UIImageView()
//                imageView.width = 100
//                imageView.height = 100
//                let url = attachment.contentURL
//                imageView.kf.setImage(with: ImageResource(downloadURL: url!), completionHandler: { (image, error,cacheType, url) in
//                    if let image = image {
//                        let size = image.size
//                        let maxWidth = UIScreen.main.bounds.width - 86 - self.postLabel.frame.origin.x - 5
//                        imageView.width = image.size.width
//                        imageView.height = image.size.height
//                        if size.width > maxWidth {
//                            let scale = maxWidth / size.width
//                            imageView.width = size.width * scale
//                            imageView.height = size.height * scale
//                        }
//                    }
//                })
//                let newString = NSAttributedString.yy_attachmentString(withContent: imageView, contentMode: .scaleAspectFill, attachmentSize: imageView.frame.size, alignTo: UIFont.systemFont(ofSize: 14), alignment: .center)
//                backupString.replaceCharacters(in: range, with: newString)
//                shouldUpdate = true
//            } else if let block = attributes["DTTextBlocks"] {
//                print(block)
//            } else {
//                
//            }
//        })
//        if shouldUpdate {
//            let newLayout = YYTextLayout(container: layout.container, text: backupString)
//            self.postLabel.textLayout = newLayout
//            
//        } else {
            self.postLabel.textLayout = layout
//        }
    }
}


protocol ImageSizeChangeDelegate {
    func layoutDidChange(layout: YYTextLayout, row: Int)
    func sizeDidChange()
}
