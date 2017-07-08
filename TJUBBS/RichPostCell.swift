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
    var tableView: UITableView { get }
    func htmlContentCell(cell: RichPostCell, linkDidPress link: URL)
    func htmlContentCellSizeDidChange(cell: RichPostCell)
}


class RichPostCell: DTAttributedTextCell {
    
    let portraitImageView = UIImageView(image: UIImage(named: "default"))
    let usernameLabel = UILabel(text: "")
    let nickNameLabel = UILabel(text: "", color: .gray)
    let timeLabel = UILabel(text: "HH:mm yyyy-MM-dd", color: .lightGray, fontSize: 14)
    var moreButton = ExtendedButton()
    
    let screenSize = UIScreen.main.bounds
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func draw(_ rect: CGRect) {
        
    }
    
    var imageViews = [DTLazyImageView]()
    weak var delegate: HtmlContentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textDelegate = self
        initLayout()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textDelegate = self
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(moreButton)
        initLayout()
    }
    
    public override init!(reuseIdentifier: String!) {
        super.init(reuseIdentifier: reuseIdentifier)
        textDelegate = self
        contentView.addSubview(portraitImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(moreButton)
        initLayout()
    }
    
    func initLayout() {
        portraitImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(44).priority(999)
        }
        portraitImageView.layer.cornerRadius = 44/2
        portraitImageView.clipsToBounds = true
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(portraitImageView.snp.top)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(portraitImageView.snp.top)
            make.left.equalTo(usernameLabel.snp.right).offset(8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(4)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
        }
        
        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        attributedTextContextView.snp.makeConstraints { make in
            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
            make.left.equalTo(portraitImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        moreButton.setBackgroundImage(UIImage(named: "更多操作"), for: .normal)
        moreButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-18)
            make.top.equalTo(portraitImageView.snp.top)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        portraitImageView.kf.cancelDownloadTask()
        portraitImageView.addTapGestureRecognizer { _ in
        }
        usernameLabel.addTapGestureRecognizer { _ in
        }
//        imageViews.removeAll()
        for imageView in imageViews {
            imageView.cancelLoading()
        }
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
        attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        attributedTextContextView.shouldDrawImages = true

        usernameLabel.text = thread.authorID != 0 ? thread.authorName : "匿名用户"
        nickNameLabel.text = thread.authorID != 0 ? "@"+thread.authorNickname : ""
        let timeString = TimeStampTransfer.string(from: String(thread.createTime), with: "yyyy-MM-dd HH:mm")
        timeLabel.text = timeString
        
//        self.contentView.setNeedsLayout()
//        self.contentView.layoutIfNeeded()
        nickNameLabel.sizeToFit()
        usernameLabel.sizeToFit()
        // 68: avatar and margin // 38: moreButton // 4: padding
        let maxWidth = UIScreen.main.bounds.width - 68 - 38 - 4
        if nickNameLabel.width + 8 + usernameLabel.width > maxWidth {
            if usernameLabel.width >= maxWidth {
                usernameLabel.snp.remakeConstraints { make in
                    make.top.equalTo(portraitImageView.snp.top)
                    make.width.equalTo(maxWidth)
                    make.left.equalTo(portraitImageView.snp.right).offset(8)
                }
                nickNameLabel.snp.remakeConstraints { make in
                    make.top.equalTo(portraitImageView.snp.top)
                    make.left.equalTo(usernameLabel.snp.right).offset(8)
                    make.width.equalTo(0)
                }
            } else {
                nickNameLabel.snp.remakeConstraints { make in
                    make.top.equalTo(portraitImageView.snp.top)
                    make.left.equalTo(usernameLabel.snp.right).offset(8)
                    make.width.equalTo(maxWidth - usernameLabel.width - 8)
                }
            }
        } else {
            usernameLabel.snp.makeConstraints { make in
                make.top.equalTo(portraitImageView.snp.top)
                make.left.equalTo(portraitImageView.snp.right).offset(8)
            }
            nickNameLabel.snp.makeConstraints { make in
                make.top.equalTo(portraitImageView.snp.top)
                make.left.equalTo(usernameLabel.snp.right).offset(8)
            }
        }
//        attributedTextContextView.sizeToFit()
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
        let timeString = "\(post.floor) 楼 " + TimeStampTransfer.string(from: String(post.createTime), with: "yyyy-MM-dd HH:mm")
        timeLabel.text = timeString
        nickNameLabel.text = post.authorID != 0 ? "@"+post.authorNickname : ""
        nickNameLabel.sizeToFit()
        usernameLabel.sizeToFit()
        // 68: avatar and margin // 38: moreButton // 4: padding
        let maxWidth = UIScreen.main.bounds.width - 68 - 38 - 4
        if nickNameLabel.width + 8 + usernameLabel.width > maxWidth {
            if usernameLabel.width >= maxWidth {
                usernameLabel.snp.remakeConstraints { make in
                    make.top.equalTo(portraitImageView.snp.top)
                    make.width.equalTo(maxWidth)
                    make.left.equalTo(portraitImageView.snp.right).offset(8)
                }
                nickNameLabel.snp.remakeConstraints { make in
                    make.top.equalTo(portraitImageView.snp.top)
                    make.left.equalTo(usernameLabel.snp.right).offset(8)
                    make.width.equalTo(0)
                }
            } else {
                nickNameLabel.snp.remakeConstraints { make in
                    make.top.equalTo(portraitImageView.snp.top)
                    make.left.equalTo(usernameLabel.snp.right).offset(8)
                    make.width.equalTo(maxWidth - usernameLabel.width - 8)
                }
            }
        } else {
            usernameLabel.snp.makeConstraints { make in
                make.top.equalTo(portraitImageView.snp.top)
                make.left.equalTo(portraitImageView.snp.right).offset(8)
            }
            nickNameLabel.snp.makeConstraints { make in
                make.top.equalTo(portraitImageView.snp.top)
                make.left.equalTo(usernameLabel.snp.right).offset(8)
            }
        }
        attributedTextContextView.relayoutText()
//        // 86: margin
//        let aWidth = UIScreen.main.bounds.width - 86
//        let height = attributedTextContextView.suggestedFrameSizeToFitEntireStringConstrainted(toWidth: aWidth)
//        attributedTextContextView.snp.remakeConstraints { make in
//            make.top.equalTo(portraitImageView.snp.bottom).offset(8)
//            make.left.equalTo(portraitImageView.snp.right).offset(8)
//            make.height.equalTo(height).priority(999)
//            make.width.equalTo(aWidth)
//            make.bottom.equalToSuperview().offset(-8)
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Fix warning when layer is to high
        DTAttributedTextContentView.setLayerClass(NSClassFromString("DTTiledLayerWithoutFade"))
        contentView.setNeedsUpdateConstraints()
        contentView.updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            imageView.shouldShowProgressiveDownload = true
            imageView.delegate = self
            imageView.url = attachment.contentURL
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
            imageView.shouldShowProgressiveDownload = true
            imageViews.append(imageView)
//            self.delegate?.htmlContentCellSizeDidChange(cell: self)
            return imageView
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
//                let qouteOffset: CGFloat = 10
//            let maxWidth = v.bounds.width - v.edgeInsets.left - v.edgeInsets.right - qouteOffset
            attachment.displaySize = CGSize(width: size.width, height: size.height)
            // 5: offset 86: margin
                let maxWidth = UIScreen.main.bounds.width - 86 - v.frame.origin.x - 5
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
//            self.contentView.setNeedsLayout()
//            self.contentView.layoutIfNeeded()
                self.attributedTextContextView.layouter = nil
                self.attributedTextContextView.relayoutText()
//            // 86: margin
//            let aWidth = UIScreen.main.bounds.width - 86
//            let height = attributedTextContextView.suggestedFrameSizeToFitEntireStringConstrainted(toWidth: aWidth)
//            
//            attributedTextContextView.snp.remakeConstraints { make in
//                make.height.equalTo(height).priority(999)
//                make.width.equalTo(aWidth)
//                make.top.equalTo(portraitImageView.snp.bottom).offset(8)
//                make.left.equalTo(portraitImageView.snp.right).offset(8)
//                make.right.equalToSuperview().offset(-18)
//                make.bottom.equalToSuperview().offset(-8)
//            }
                self.delegate?.htmlContentCellSizeDidChange(cell: self)
//            }
        }
    }
}
