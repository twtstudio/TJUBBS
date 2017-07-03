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
    func htmlContentCell(cell: RichPostCell, linkDidPress link: URL)
    func htmlContentCellSizeDidChange(cell: RichPostCell)
}


class RichPostCell: DTAttributedTextCell {
    
    let portraitImageView = UIImageView(image: UIImage(named: "头像2"))
    let usernameLabel = UILabel(text: "")
    let nickNameLabel = UILabel(text: "", color: .gray)
    let timeLabel = UILabel(text: "HH:mm yyyy-MM-dd", color: .lightGray, fontSize: 14)
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
        initLayout()
    }
    
    public override init!(reuseIdentifier: String!) {
        super.init(reuseIdentifier: reuseIdentifier)
        textDelegate = self
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
//        contentView.addSubview(favorButton)
//        contentView.addSubview(floorLabel)
        contentView.addSubview(nickNameLabel)
//        favorButton.isHidden = true
        favorButton.isUserInteractionEnabled = false
        floorLabel.isHidden = false
        initLayout()
    }
    
    func initLayout() {
        portraitImageView.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(screenSize.height*(120/1920))
        }
        portraitImageView.layer.cornerRadius = screenSize.height*(120/1920)/2
        portraitImageView.clipsToBounds = true
        
        usernameLabel.sizeToFit()
        usernameLabel.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        
        //        let timeString = TimeStampTransfer.string(from: String(post.createTime), with: "HH:mm yyyy-MM-dd")
        timeLabel.sizeToFit()
        timeLabel.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        //        nickNameLabel.sizeToFit()

        
//        floorLabel.sizeToFit()
        let fooView = UIView()
        self.contentView.addSubview(fooView)
        fooView.backgroundColor = .white
        fooView.addSubview(floorLabel)
        floorLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

//        floorLabel.snp.makeConstraints {
//            make in
//            make.centerY.equalTo(usernameLabel)
//            make.right.equalToSuperview().offset(-16)
//        }
        fooView.snp.makeConstraints {
            make in
            make.centerY.equalTo(usernameLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        
        nickNameLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(usernameLabel)
            make.left.equalTo(usernameLabel.snp.right).offset(3)
//            make.right.lessThanOrEqualTo(floorLabel.snp.left)
            //            make.right.equalTo(floorLabel.snp.left)
        }

        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        attributedTextContextView.sizeToFit()
        attributedTextContextView.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
//            make.right.equalToSuperview().offset(-24)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-7)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        portraitImageView.kf.cancelDownloadTask()
//        imageViews.removeAll()
    }
    
    func load(thread: ThreadModel, boardName: String) {
//        let html = BBCodeParser.parse(string: thread.content)
//        let noBB = BBCodeParser.cleanBBCode(string: thread.content)
        let html = Markdown.parse(string: thread.content)

        let option = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      DTDefaultFontSize: 14.0,
                      DTDefaultFontFamily: UIFont.systemFont(ofSize: 14).familyName,
                      DTDefaultTextColor: UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.00),
                      DTDefaultFontName: UIFont.systemFont(ofSize: 14).fontName] as [String : Any]
        setHTMLString(html, options: option)
//        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 0)
//        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        attributedTextContextView.shouldDrawImages = true

        let colorName = NSAttributedString(string: boardName, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
                                                                                   NSForegroundColorAttributeName: UIColor.BBSBlue])
        floorLabel.attributedText = colorName
//        floorLabel.text = boardName
//        floorLabel.sizeToFit()
//        floorLabel.snp.remakeConstraints { make in
//            make.centerY.equalTo(usernameLabel)
//            make.right.equalToSuperview().offset(-16)
//        }
//        
//        usernameLabel.snp.makeConstraints { make in
//            make.top.equalTo(portraitImageView)
//            make.left.equalTo(portraitImageView.snp.right).offset(8)
//        }
//        
//        nickNameLabel.snp.remakeConstraints { make in
//            make.centerY.equalTo(usernameLabel)
//            make.left.equalTo(usernameLabel.snp.right).offset(3)
//            //            make.right.equalTo(floorLabel.snp.left)
//        }

        usernameLabel.text = thread.authorID != 0 ? thread.authorName : "匿名用户"
        nickNameLabel.text = thread.authorID != 0 ? "@"+thread.authorNickname : ""
        let timeString = TimeStampTransfer.string(from: String(thread.createTime), with: "yyyy-MM-dd HH:mm")
        timeLabel.text = timeString
        
        floorLabel.isHidden = false
        
        // FIXME: 收藏
//        favorButton.isHidden = false
//        favorButton.addTarget { button in
//            if let button = button as? UIButton {
//                BBSJarvis.collect(threadID: thread.id) {_ in
//                    button.setImage(UIImage(named: "已收藏"), for: .normal)
//                    button.tag = 1
//                }
//            }
//        }
        favorButton.isUserInteractionEnabled = true
        attributedTextContextView.relayoutText()
    }
    
    func load(post: PostModel) {
//        let html = BBCodeParser.parse(string: post.content)
//        let noBB = BBCodeParser.cleanBBCode(string: post.content)
//        let noBB = String.clearBBCode(string: post.content)
        let html = Markdown.parse(string: post.content)

        let option = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      DTDefaultFontSize: 14.0,
                      DTDefaultFontFamily: UIFont.systemFont(ofSize: 14).familyName,
                      DTDefaultTextColor: UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.00),
                      DTDefaultFontName: UIFont.systemFont(ofSize: 14).fontName] as [String : Any]
        setHTMLString(html, options: option)
//        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 0)
        attributedTextContextView.shouldDrawImages = true

        usernameLabel.text = post.authorID != 0 ? post.authorName : "匿名用户"
        let timeString = TimeStampTransfer.string(from: String(post.createTime), with: "yyyy-MM-dd HH:mm")
        timeLabel.text = timeString
        floorLabel.text = "\(post.floor) 楼"
        nickNameLabel.text = post.authorID != 0 ? "@"+post.authorNickname : ""
        floorLabel.isHidden = false
        favorButton.isHidden = true
        attributedTextContextView.relayoutText()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setNeedsUpdateConstraints()
        contentView.updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
    
    
    deinit {
        for imageView in imageViews {
            imageView.delegate = nil
        }
        self.imageViews.removeAll()
        self.delegate = nil
        self.textDelegate = nil
    }
}


extension RichPostCell: DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor string: NSAttributedString!, frame: CGRect) -> UIView! {
        
        let attributes = string.attributes(at: 0, effectiveRange: nil)
        let url = attributes[DTLinkAttribute]
        let identifier = attributes[DTGUIDAttribute] as? String
        
        let button = DTLinkButton(frame: frame)
        button.url = url as! URL!
        button.guid = identifier
        button.minimumHitSize = CGSize(width: 25, height: 25)
        button.addTarget { sender in
            if let url = (sender as? DTLinkButton)?.url {
                self.delegate?.htmlContentCell(cell: self, linkDidPress: url)
            }
        }
        
        return button
    }
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, didDraw layoutFrame: DTCoreTextLayoutFrame!, in context: CGContext!) {
        attributedTextContextView.layouter = nil
        attributedTextContextView.relayoutText()
    }
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if let attachment = attachment as? DTImageTextAttachment {
//            let size = self.aspectFitSizeForURL()
//            let aspectFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: size.width, height: size.height)
            
            let imageView = DTLazyImageView(frame: frame)
//            let imageView = DTLazyImageView(frame: aspectFrame)
            
            imageView.delegate = self
            imageView.url = attachment.contentURL
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
            imageView.shouldShowProgressiveDownload = true
            imageViews.append(imageView)
//            self.delegate?.htmlContentCellSizeDidChange(cell: self)

            return imageView
        } else if let attachment = attachment as? DTIframeTextAttachment {
            let videoView = DTWebVideoView(frame: frame)
            videoView.attachment = attachment
            return videoView
        }
        return nil
    }
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, shouldDrawBackgroundFor textBlock: DTTextBlock!, frame: CGRect, context: CGContext!, for layoutFrame: DTCoreTextLayoutFrame!) -> Bool {
        // fun functional programming
        // let rect = CGRect.insetBy(frame)(dx: 1, dy: 1)
        let roundedRect = UIBezierPath(roundedRect: CGRect.insetBy(frame)(dx: 1, dy: 1), cornerRadius: 2)
        let color = textBlock.backgroundColor.cgColor
        context.setFillColor(color)
        context.addPath(roundedRect.cgPath)
        context.fillPath()
        
        let rectangleRect = UIBezierPath(rect: CGRect(x: frame.origin.x, y: frame.origin.y+1, width: 4, height: frame.size.height-2))
//        let rectangleRect = UIBezierPath(roundedRect: CGRect(x: frame.origin.x, y: frame.origin.y, width: 4, height: frame.size.height), cornerRadius: 2)
        context.addPath(rectangleRect.cgPath)
        context.setFillColor(UIColor(hex6: 0x2565ac).cgColor)
        context.fillPath()
        
        return false
    }
    
    // MARK: DTLazyImageViewDelegate
    func lazyImageView(_ lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        let predicate = NSPredicate(format: "contentURL == %@", lazyImageView.url as CVarArg)
        let attachments = attributedTextContextView.layoutFrame.textAttachments(with: predicate) as? [DTImageTextAttachment] ?? []
//        let attachments = [lazyImageView.]
        var shouldUpdate = false
        for attachment in attachments {
//            if attachment.originalSize.equalTo(CGSize.zero) {
                attachment.originalSize = size
                let v = attributedTextContextView!
                let qouteOffset: CGFloat = 10
                let maxWidth = v.bounds.width - v.edgeInsets.left - v.edgeInsets.right - qouteOffset
//                attachment.image = lazyImageView.image
                if size.width > maxWidth {
                    let scale = maxWidth / size.width
                    attachment.displaySize = CGSize(width: size.width * scale, height: size.height * scale)
                }
                shouldUpdate = true
//            }
        }
        if shouldUpdate {
            // layout might have changed due to image sizes
            // do it on next run loop because a layout pass might be going on
//            DispatchQueue.main.async {
                self.attributedTextContextView.layouter = nil
                self.attributedTextContextView.relayoutText()
                self.delegate?.htmlContentCellSizeDidChange(cell: self)
//            }
        }
    }
}
