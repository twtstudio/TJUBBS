
//
//  HCRichCellLayout.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import YYText
import Kingfisher
import DTCoreText

class HCRichCellLayout: NSObject {
    var textLayout: YYTextLayout?
    var attributedString: NSAttributedString?
    
    required init(markdown: String, width: CGFloat) {
        super.init()
        let html = Markdown.parse(string: markdown)
        let data = html.data(using: .utf8)
        let option = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      DTDefaultFontSize: 14.0,
                      DTDefaultFontFamily: UIFont.systemFont(ofSize: 14).familyName,
                      DTDefaultTextColor: UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.00),
                      DTDefaultFontName: UIFont.systemFont(ofSize: 14).fontName] as [String : Any]
        
//        let attributedString = try? NSAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        let attributedString = try? NSAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        let attributedString = NSAttributedString(htmlData: data, options: option, documentAttributes: nil)!
        let backup = NSMutableAttributedString(attributedString: attributedString)
        attributedString.enumerateAttributes(in: NSMakeRange(0, attributedString.length), options: .reverse, using: { (attributes, range, stop) in
            if let attachment = attributes["NSAttachment"] as? DTImageTextAttachment {
                let imageView = UIImageView()
                imageView.width = 100
                imageView.height = 100
                if let url = attachment.contentURL {
                    imageView.kf.setImage(with: ImageResource(downloadURL: url), completionHandler: { (image, error,cacheType, url) in
                        if let image = image {
                            let size = image.size
                            //                                                let maxWidth = UIScreen.main.bounds.width - 86 - self.postLabel.frame.origin.x - 5
                            let maxWidth = UIScreen.main.bounds.width - 86 - 5
                            imageView.width = image.size.width
                            imageView.height = image.size.height
                            if size.width > maxWidth {
                                let scale = maxWidth / size.width
                                imageView.width = size.width * scale
                                imageView.height = size.height * scale
                            }
                        }
                })
                }
                let newString = NSAttributedString.yy_attachmentString(withContent: imageView, contentMode: .scaleAspectFill, attachmentSize: imageView.frame.size, alignTo: UIFont.systemFont(ofSize: 14), alignment: .center)
                backup.replaceCharacters(in: range, with: newString)
            } else if let block = attributes["DTTextBlocks"] {
                print(block)
            } else {
                
            }
        })

        self.attributedString = backup
        let textContainer = YYTextContainer(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        textLayout = YYTextLayout(container: textContainer, text: backup)
    }
}
