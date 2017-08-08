//
//  ClassExtensions.swift
//  TJUBBS
//
//  Created by JinHongxu and AllenX on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(title: String, color: UIColor = .black, fontSize: Int = 15, isConfirmButton: Bool = false) {
        self.init()
        if isConfirmButton == false {
            self.setTitle(title, for: .normal)
            self.setTitleColor(color, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        } else {
            //ugly
            var spaceTitle = title
            let index = title.index(after: title.startIndex)
            spaceTitle.insert(contentsOf: "  ".characters, at: index)
            self.setTitle(spaceTitle, for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.setBackgroundImage(UIImage.init(color: UIColor.lightGray), for: .disabled)
            self.setBackgroundImage(UIImage.init(color: UIColor.BBSBlue), for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            self.layer.cornerRadius = 5.0
            self.clipsToBounds = true
        }
    }
    
    static func confirmButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(color: .lightGray), for: .disabled)
        button.setBackgroundImage(UIImage(color: .BBSBlue), for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.font = UIFont.flexibleFont(ofBaseSize: 15)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        
        return button
    }
    
    static func borderButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.BBSBlue, for: .normal)
        button.titleLabel?.font = UIFont.flexibleFont(ofBaseSize: 15)
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.BBSBlue.cgColor
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        
        return button
    }
    convenience init(imageName: String) {
        self.init()
        self.setImage(UIImage(named: imageName), for: .normal)
    }
    
}

extension UIButton {
    //TODO: want to change "withBlock" into "_"
    func addTarget(for controlEvents: UIControlEvents = .touchUpInside, withBlock block: @escaping newDataBlock) {
        self.blockm = blockm ?? BlockContainer()
        blockm?.newDataBlock = block
        self.addTarget(self, action: #selector(self.callback(sender:)), for: controlEvents)
    }
    
    func callback(sender: UIButton) {
        self.blockm?.newDataBlock?(sender)
    }
}

extension UILabel {
    convenience init(text: String, color: UIColor = UIColor.black, fontSize: Int = 15) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
//        self.sizeToFit()
    }
    
    static func roundLabel(text: String, textColor: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.BBSBadgeRed) -> UILabel {
        let label = UILabel(text: " \(text) ", color: textColor, fontSize: 12)
        label.backgroundColor = backgroundColor
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        
        return label
    }
    
    convenience init(text: String, boldFontSize: CGFloat) {
        self.init()
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: boldFontSize)
        self.sizeToFit()
    }
}


extension UIColor {
    open class var BBSBlue: UIColor {
        return UIColor(red: 25.0/255, green: 126.0/255, blue: 225.0/255, alpha: 1.0)
    }
    
    open class var BBSLightBlue: UIColor {
        return UIColor(red: 26.0/255, green: 184.0/255, blue: 226.0/255, alpha: 1.0)
    }
    
    open class var BBSBadgeOrange: UIColor {
        return UIColor(red: 239.0/255, green: 144.0/255, blue: 108.0/255, alpha: 1.0)
    }
    
    open class var BBSBadgeRed: UIColor {
        return UIColor(red: 232.0/255, green: 94.0/255, blue: 58.0/255, alpha: 1.0)
    }
    
    open class var BBSRed: UIColor {
        return UIColor(red: 248.0/255, green: 48.0/255, blue: 48.0/255, alpha: 1.0)
    }
    
    open class var BBSLightGray: UIColor {
        return UIColor(red: 244.0/255, green: 244.0/255, blue: 246.0/255, alpha: 1.0)
    }

    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        // TODO: below
        // Store Hex converted UIColours (R, G, B, A) to a persistent file (.plist)
        // And when initializing the app, read from the plist into the memory as a static struct (Metadata.Color)
        let divisor = CGFloat(255)
        let r = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let g = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let b = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension UIViewController {
    
    func becomeKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func keyboardWillShow() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = -40
        })
    }
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

}

extension UIImage {
    
    //pure color image
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    //resized image may cause some problem
    static func resizedImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.clip(to: rect, mask: self.cgImage!)
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
}

extension UIImageView {
    
    func resize(newFrame: CGRect) {
        // self.frame = newFrame
        //self.image = UIImage.resizedImage(image: self.image!, scaledToSize: newFrame.size)
    }
}

extension UIView {
    
    typealias newDataBlock = (Any) -> Void
    
    // 关联属性的key
    private struct associatedKeys {
        static var newDataBlockKey = "GestureBlockKey"
    }
    
    fileprivate class BlockContainer: NSObject, NSCopying {
        var newDataBlock: newDataBlock?
        func copy(with zone: NSZone? = nil) -> Any {
            return self
        }
    }
    
    // fileprivate: 文件内作用域 为了让上面能用
    fileprivate var blockm: BlockContainer? {
        get {
            if let newDataBlock = objc_getAssociatedObject(self, &associatedKeys.newDataBlockKey) as? BlockContainer {
                return newDataBlock
            }
            return nil
        }
        set(newValue) {
            objc_setAssociatedObject(self, &associatedKeys.newDataBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    
    func addTapGestureRecognizer(gestureHandler: ((UITapGestureRecognizer)->(Void))? = nil, block: @escaping newDataBlock) {
        self.blockm = blockm ?? BlockContainer()
        blockm?.newDataBlock = block
        //jhx edit
        self.isUserInteractionEnabled = true
        //end edit
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(sender:)))
        gestureHandler?(tapRecognizer)
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func tapped(sender: UITapGestureRecognizer) {
        self.blockm?.newDataBlock?(sender)
    }
}

extension UIFont {
    static func flexibleFont(ofBaseSize size: CGFloat) -> UIFont {
        let width = UIScreen.main.bounds.width
        var flexSize = size
        if width <= 320 {
            // small size
            flexSize = size
        } else if width >= 414 {
            // big size
            flexSize = size*1.1
        }
        return UIFont.systemFont(ofSize: flexSize)
    }
}


extension String {
    static func clearBBCode(string: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\[.*?\\]", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, string.utf16.count)
        var res = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
        res = res.replacingOccurrences(of: "&#91;", with: "[")
        res = res.replacingOccurrences(of: "&#93;", with: "]")
        res = res.replacingOccurrences(of: "&rsquo;", with: "'")
        return res
    }
}

extension Date {
    static var today: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let today = formatter.string(from: date)
        return today
    }
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block: (Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

extension UIView {
    var x: CGFloat {
        set(newValue) {
            self.frame = CGRect(x: newValue, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set(newValue) {
            self.frame = CGRect(x: frame.origin.x, y: newValue, width: frame.size.width, height: frame.size.height)
        }
        get {
            return frame.origin.y
        }
    }
    
    var height: CGFloat {
        set(newValue) {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: newValue)
        }
        get {
            return frame.size.height
        }
    }
    
    var width: CGFloat {
        set(newValue) {
            self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.size.height)
        }
        get {
            return frame.size.width
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return !unicodeScalars.filter { $0.isEmoji }.isEmpty
    }
    
    var containsOnlyEmoji: Bool {
        
        return unicodeScalars.first(where: { !$0.isEmoji && !$0.isZeroWidthJoiner }) == nil
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
    
    var containsChineseCharacters: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
}

extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000 ... 0x1F77F, // Emoticons
        0x2100 ... 0x27BF, // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F, // Variation Selectors
        0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}


extension UIImageView {
    convenience init?(imageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: imageName) else {
            return nil
        }
        foo = UIImage.resizedImage(image: foo, scaledToSize: desiredSize)
        self.init()
        image = foo
    }
}

extension NSAttributedString {
    var attachmentRanges: [(attachment: ImageTextAttachment, range: NSRange)] {
        var ranges = [(ImageTextAttachment, NSRange)]()
        let fullRange = NSRange(location: 0, length: self.length)
        self.enumerateAttribute(NSAttachmentAttributeName, in: fullRange) { value, range, _ in
            if let attachment = value as? ImageTextAttachment {
                ranges.append((attachment, range))
            }
        }
        return ranges
    }
}
