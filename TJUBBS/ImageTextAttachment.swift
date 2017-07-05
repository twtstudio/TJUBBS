//
//  ImageTextAttachment.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ImageTextAttachment: NSTextAttachment {
    var block: ((CGRect)->())?
    var progressView = ProgressView()
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let rect = super.attachmentBounds(for: textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        var fooRect = rect
        fooRect.origin = position
        if let padding = textContainer?.lineFragmentPadding {
            fooRect.origin.x += padding
        }
        self.block?(fooRect)
        return rect
    }
    
    
}
