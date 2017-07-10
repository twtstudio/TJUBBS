//
//  YYRichPostCell.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import YYText
import DTCoreText
import Kingfisher

class YYRichPostCell: UITableViewCell {

    let portraitImageView = UIImageView(image: UIImage(named: "default"))
    let usernameLabel = UILabel(text: "")
    let nickNameLabel = UILabel(text: "", color: .gray)
    let timeLabel = UILabel(text: "HH:mm yyyy-MM-dd", color: .lightGray, fontSize: 14)
    let moreButton = ExtendedButton()
//    let contentLabel = YYLabel()
    let textView = DTAttributedTextContentView()
    var imageDelegate: HtmlContentCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // TODO: abstract a layout here
        portraitImageView.frame = CGRect(x: 10, y: 10, width: 44, height: 44)
        textView.frame = CGRect(x: 64, y: 64, width: UIScreen.main.bounds.width-86, height: 1)
        
        contentView.addSubview(portraitImageView)
        contentView.addSubview(textView)
        textView.delegate = self
    }
    
    func setLayout(height: CGFloat) {
        textView.height = height
        contentView.height = 10 + 44 + 10 + height + 10
        self.height = 10 + 44 + 10 + height + 10
    }
    
    func setContent(markdown: String) {
        let html = Markdown.parse(string: markdown)
        let data = html.data(using: .utf8)
        let option = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      DTDefaultFontSize: 14.0,
                      DTDefaultFontFamily: UIFont.systemFont(ofSize: 14).familyName,
                      DTDefaultTextColor: UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.00),
                      DTDefaultFontName: UIFont.systemFont(ofSize: 14).fontName] as [String : Any]
        
        let attributedString = NSAttributedString(htmlData: data, options: option, documentAttributes: nil)
        self.textView.attributedString = attributedString
//        let size = self.textView.sizeThatFits(CGSize(width: (self.view.width - 86), height: CGFloat.greatestFiniteMagnitude))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension YYRichPostCell: DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
//    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
//        if let attachment = attachment as? DTImageTextAttachment {
//            //            let size = self.aspectFitSizeForURL()
//            //            let aspectFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: size.width, height: size.height)
//            
//            let imageView = UIImageView(frame: frame)
//            //            let imageView = DTLazyImageView(frame: aspectFrame)
////            imageView.shouldShowProgressiveDownload = true
////            imageView.delegate = self
////            imageView.url = attachment.contentURL
//            imageView.contentMode = UIViewContentMode.scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
////            imageView.shouldShowProgressiveDownload = true
////            imageView.kf.setImage(with: ImageResource(downloadURL: attachment.contentURL), placeholder: nil, completionHandler: { (image, error, type, url) in
////                if let image = image {
////                    imageView.image = image
////                    
//////                    imageView
////                }
////            })
//        }
//        return nil
//    }
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
            //            self.delegate?.htmlContentCellSizeDidChange(cell: self)
            return imageView
        }
        return nil
    }

    
    func lazyImageView(_ lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        let predicate = NSPredicate(format: "contentURL == %@", lazyImageView.url as CVarArg)
        
        let attachments = textView.layoutFrame.textAttachments(with: predicate) as? [DTImageTextAttachment] ?? []
        //        let attachments = [lazyImageView.]
        var shouldUpdate = false
        for attachment in attachments {
            //            if attachment.originalSize.equalTo(CGSize.zero) {
            attachment.originalSize = size
            let v = textView
            attachment.displaySize = CGSize(width: size.width, height: size.height)
            // 5: offset 86: margin
            let maxWidth = UIScreen.main.bounds.width - 86 - v.frame.origin.x - 5
            //                attachment.image = lazyImageView.image
            if size.width > maxWidth {
                let scale = maxWidth / size.width
                attachment.displaySize = CGSize(width: size.width * scale, height: size.height * scale)
            }
            shouldUpdate = true
        }
        textView.layouter = nil
        textView.relayoutText()
        
//        textView.height = textView.sizeThatFits(CGSize(width: (UIScreen.main.bounds.width - 86), height: CGFloat.greatestFiniteMagnitude)).height
//        self.height = 10 + 44 + 10 + height + 10

        if shouldUpdate {
            self.imageDelegate?.imageCellSizeDidChange?(cell: self, row: self.tag)
//            self.imageDelegate?.imageCellSizeDidChange?(cell: self)
        }
    }
}
