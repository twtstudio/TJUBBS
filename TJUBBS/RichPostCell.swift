//
//  RichPostCell.swift
//  TJUBBS
//
//  Created by Halcao on 2017/6/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import DTCoreText
import Kingfisher

protocol HtmlContentCellDelegate: class {
    func htmlContentCell(cell: RichPostCell, linkDidPress link:NSURL)
    func htmlContentCellSizeDidChange(cell: RichPostCell)
}


class RichPostCell: DTAttributedTextCell {
    
    let portraitImageView = UIImageView()
    let usernameLabel = UILabel(text: "")
    let timeLabel = UILabel(text: "", fontSize: 14)
    let favorButton = UIButton(imageName: "收藏")
    var floorLabel = UILabel(text: "", fontSize: 14)

    let screenSize = UIScreen.main.bounds
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var imageViews = [DTLazyImageView]()
    weak var delegate: HtmlContentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textDelegate = self
    }
    
    public override init!(reuseIdentifier: String!) {
        super.init(reuseIdentifier: reuseIdentifier)
        textDelegate = self
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(favorButton)
        contentView.addSubview(floorLabel)
        favorButton.isHidden = true
        favorButton.isUserInteractionEnabled = false
        floorLabel.isHidden = true
    }
    
    func initUI(thread: ThreadModel) {
        let portraitImage = UIImage(named: "头像2")
        let url = URL(string: BBSAPI.avatar(uid: thread.authorID))
        let cacheKey = "\(thread.authorID)" + Date.today
        portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        portraitImageView.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(120/1920))
        }
        portraitImageView.layer.cornerRadius = screenSize.height*(120/1920)/2
        portraitImageView.clipsToBounds = true
        
        usernameLabel.text = thread.authorID != 0 ? thread.authorName : "匿名用户"
        usernameLabel.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        let timeString = TimeStampTransfer.string(from: String(thread.createTime), with: "yyyy-MM-dd HH:mm")
        timeLabel.text = timeString
        timeLabel.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        floorLabel.isHidden = true
        favorButton.isHidden = false
        favorButton.isUserInteractionEnabled = true
        favorButton.snp.makeConstraints {
            make in
            make.centerY.equalTo(portraitImageView)
            make.right.equalToSuperview()
            make.width.height.equalTo(screenSize.height*(144/1920))
        }
        favorButton.addTarget { button in
            if let button = button as? UIButton {
                BBSJarvis.collect(threadID: thread.id) {_ in
                    button.setImage(UIImage(named: "已收藏"), for: .normal)
                    button.tag = 1
                }
            }
        }
        
        self.attributedTextContextView.snp.makeConstraints { make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
//            make.height.equalTo(attr)
        }
    }
    
    func initUI(post: PostModel) {
        let portraitImage = UIImage(named: "头像2")
        let url = URL(string: BBSAPI.avatar(uid: post.authorID))
        let cacheKey = "\(post.authorID)" + Date.today
        portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        portraitImageView.snp.makeConstraints {
            make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(120/1920))
        }
        portraitImageView.layer.cornerRadius = screenSize.height*(120/1920)/2
        portraitImageView.clipsToBounds = true
        
        usernameLabel.text = post.authorName
        usernameLabel.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        //        let timeString = TimeStampTransfer.string(from: String(post.createTime), with: "HH:mm yyyy-MM-dd")
        let timeString = TimeStampTransfer.string(from: String(post.createTime), with: "yyyy-MM-dd HH:mm")
        timeLabel.text = timeString
        timeLabel.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        favorButton.isHidden = true
        floorLabel.isHidden = false
        floorLabel.text = "\(post.floor) 楼"
        floorLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(usernameLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.attributedTextContextView.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-8)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    deinit {
        for imageView in imageViews {
            imageView.delegate = nil
        }
    }
}

extension RichPostCell {
    
    func aspectFitSizeForURL() -> CGSize {
        //        let imageSize = imageSizes[url] ?? CGSizeMake(4, 3)
        let imageSize = CGSize(width: 4, height: 3)
        return self.aspectFitImageSize(size: imageSize)
    }
    
    func aspectFitImageSize(size : CGSize) -> CGSize {
        if size.equalTo(.zero) {
            return size
        }
        return CGSize(width: 40, height: 40)
        //        return CGSizeMake(self.bounds.size.width, self.bounds.size.width/size.width * size.height)
    }
    
}

extension RichPostCell: DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor string: NSAttributedString!, frame: CGRect) -> UIView! {
        
        let attributes = string.attributes(at: 0, effectiveRange: nil)
        let url = attributes[DTLinkAttribute] as? NSURL
        let identifier = attributes[DTGUIDAttribute] as? String
        
        let button = DTLinkButton(frame: frame)
        button.url = url as URL!
        button.guid = identifier
        button.minimumHitSize = CGSize(width: 25, height: 25)
        button.addTarget { sender in
            if let url = (sender as? DTLinkButton)?.url {
                self.delegate?.htmlContentCell(cell: self, linkDidPress: url as NSURL)
            }
        }
        
        return button
    }
    
//    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewForLink url: URL!, identifier: String!, frame: CGRect) -> UIView! {
//        print(url)
//    }
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if let attachment = attachment as? DTImageTextAttachment {
            // FIXME: may Crash
            let size = self.aspectFitSizeForURL()
            let aspectFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: size.width, height: size.height)
            
            let imageView = DTLazyImageView(frame: aspectFrame)
            
            imageView.delegate = self
            imageView.url = attachment.contentURL
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
            imageView.shouldShowProgressiveDownload = true
            imageViews.append(imageView)
            
            return imageView
        }else if let attachment = attachment as? DTIframeTextAttachment {
            let videoView = DTWebVideoView(frame: frame)
            videoView.attachment = attachment
            return videoView
        }
        return nil
    }
        
    // MARK: DTLazyImageViewDelegate
    func lazyImageView(_ lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        let predicate = NSPredicate(format: "contentURL == %@", lazyImageView.url as CVarArg)
        let attachments = attributedTextContextView.layoutFrame.textAttachments(with: predicate) as? [DTImageTextAttachment] ?? []
        for attachment in attachments {
            attachment.originalSize = size
            let v = attributedTextContextView!
            let maxWidth = v.bounds.width - v.edgeInsets.left - v.edgeInsets.right
            if size.width > maxWidth {
                let scale = maxWidth / size.width
                attachment.displaySize = CGSize(width: size.width * scale, height: size.height * scale)
            }
        }
        attributedTextContextView.layouter = nil
        attributedTextContextView.relayoutText()
        self.delegate?.htmlContentCellSizeDidChange(cell: self)

//
//        let url = lazyImageView.url
//        //        let pred = NSPredicate(format: "contentURL == %@", url as! CVarArg)
//        let pred = NSPredicate(format: "contentURL == %@", argumentArray: [url as Any])
//        
//        var needsNotifyNewImageSize = false
//        if let layoutFrame = self.attributedTextContextView.layoutFrame {
//            let attachments = layoutFrame.textAttachments(with: pred)
//            
//            for one in attachments! {
//                if let one = one as? DTImageTextAttachment {
//                    if one.originalSize.equalTo(.zero) {
//                        one.originalSize = aspectFitImageSize(size: size)
//                        needsNotifyNewImageSize = true
//                    }
//                }
//            }
//            
//            if needsNotifyNewImageSize {
//                self.attributedTextContextView.layouter = nil
//                self.attributedTextContextView.relayoutText()
//                self.delegate?.htmlContentCellSizeDidChange(cell: self)
//            }
//        }
    }
}
