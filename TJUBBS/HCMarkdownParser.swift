//
//  HCMarkdownParser.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import YYText

class HCMarkdownParser: NSObject, YYTextParser {
    fileprivate let U16_COLON   = HCMarkdownParser.unicharForUnicodeScalar(":"  as UnicodeScalar)
    fileprivate let U16_SLASH   = HCMarkdownParser.unicharForUnicodeScalar("/"  as UnicodeScalar)
    fileprivate let U16_ZERO    = HCMarkdownParser.unicharForUnicodeScalar("0"  as UnicodeScalar)
    fileprivate let U16_NINE    = HCMarkdownParser.unicharForUnicodeScalar("9"  as UnicodeScalar)
    fileprivate let U16_NEWLINE = HCMarkdownParser.unicharForUnicodeScalar("\n" as UnicodeScalar)
    fileprivate let U16_RETURN  = HCMarkdownParser.unicharForUnicodeScalar("\r" as UnicodeScalar)
    fileprivate let U16_TAB     = HCMarkdownParser.unicharForUnicodeScalar("\t" as UnicodeScalar)
    fileprivate let U16_SPACE   = HCMarkdownParser.unicharForUnicodeScalar(" "  as UnicodeScalar)

    
    let headerReg = try? NSRegularExpression(pattern: "^((\\#{1,7}([^#].*))$", options: .anchorsMatchLines)
    let emphasisReg = try? NSRegularExpression(pattern: "((?<!\\*)\\*(?=[^ \\t*])(.+?)(?<=[^ \\t*])\\*(?!\\*)", options: .init(rawValue: 0))
    let strongReg = try? NSRegularExpression(pattern: "(?<!\\*)\\*{2}(?=[^ \\t*])(.+?)(?<=[^ \\t*])\\*{2}(?!\\*)", options: .init(rawValue: 0))
    let strongEmphasisReg = try? NSRegularExpression(pattern: "((?<!\\*)\\*{3}(?=[^ \\t*])(.+?)(?<=[^ \\t*])\\*{3}(?!\\*)", options: .init(rawValue: 0))
    let linkReg = try? NSRegularExpression(pattern: "!?\\[([^\\[\\]]+)\\](\\(([^\\(\\)]+)\\)|\\[([^\\[\\]]+)\\])", options: .init(rawValue: 0))
    let listReg = try? NSRegularExpression(pattern: "^[ \\t]*([*+-]|\\d+[.])[ \\t]+", options: .init(rawValue: 0))
    let quoteReg = try? NSRegularExpression(pattern: "^[ \\t]*>[ \\t>]*", options: .anchorsMatchLines)
    let notEmptyLineReg = try? NSRegularExpression(pattern: "^[ \\t]*[^ \\t]+[ \\t]*$", options: .anchorsMatchLines)
    let imageReg = try? NSRegularExpression(pattern: "!?\\[.*\\]\\(attach:([0-9]+)\\)", options: .init(rawValue: 0))

    
    public func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
        guard let text = text else {
            return false
        }
        var str = text.string
        let fullRange = NSMakeRange(0, str.characters.count)
        var matches = headerReg?.matches(in: str, options: .init(rawValue: 0), range: fullRange)
//        for match in matches?.reversed() ?? [] {
//            let content = NSMutableAttributedString(attributedString: text.attributedSubstring(from: match.rangeAt(1)))
//            print(content.string)
//            let url = "https://bbs.tju.edu.cn/api/attach/" + content.string
//            let imageView = UIImageView()
//            let attachment = YYTextAttachment(content: imageView)
//            let attributedString = NSAttributedString(attachment: attachment)
//            text.replaceCharacters(in: match.range, with: attributedString)
//        }

//        var matches = headerReg?.matches(in: str, options: .init(rawValue: 0), range: fullRange)
//        for match in matches?.reversed() ?? [] {
//            let content = NSMutableAttributedString(attributedString: text.attributedSubstring(from: match.rangeAt(3)))
//            //        print(content.string)
//            let sharpCount = match.rangeAt(3).location - match.rangeAt(2).location
//            let resultString = setHeader(size: sharpCount, attributedString: content)
//            text.replaceCharacters(in: match.range, with: resultString)
//        }
        
//        matches = emphasisReg?.matches(in: str, options: .init(rawValue: 0), range: fullRange)
//        for match in matches?.reversed() ?? [] {
//            let content = NSMutableAttributedString(attributedString: text.attributedSubstring(from: match.rangeAt(3)))
//            //        print(content.string)
//            let sharpCount = match.rangeAt(3).location - match.rangeAt(2).location
//            let resultString = setHeader(size: sharpCount, attributedString: content)
//            text.replaceCharacters(in: match.range, with: resultString)
//        }

        
        return false
    }

    func lengthOfBeginWhite(in string: String, with range: NSRange) -> Int {
        let nString = NSString(string: string)
        for i in 0..<range.length {
            let c = nString.character(at: i+range.location)
            if c != (" " as NSString).character(at: 0) && c != ("\t" as NSString).character(at: 0) && c != ("\n" as NSString).character(at: 0) {
                return i
            }
        }
        return string.characters.count
    }
    
    // FIXME
    func lengthOfEndWhite(in string: String, with range: NSRange) -> Int {
        let nString = NSString(string: string)
        for i in 0..<range.length {
            let c = nString.character(at: i+range.location)
            if c != U16_SPACE && c != U16_TAB && c != U16_NEWLINE {
                return i
            }
        }
        return string.characters.count
    }
}

// Set Attributed String
extension HCMarkdownParser {
    func setHeader(size: Int, attributedString: NSAttributedString) -> NSAttributedString {
        
        return NSAttributedString()
    }
}

extension HCMarkdownParser {
    fileprivate static func unicharForUnicodeScalar(_ unicodeScalar: UnicodeScalar) -> unichar {
        let u32 = UInt32(unicodeScalar)
        if u32 <= UInt32(UINT16_MAX) {
            return unichar(u32)
        }
        else {
            assert(false, "value must be representable in 16 bits")
            return 0
        }
    }
}
