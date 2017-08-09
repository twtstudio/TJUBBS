//
//  BubbleCell.swift
//  PiperChat
//
//  Created by Allen X on 5/16/17.
//  Copyright © 2017 allenx. All rights reserved.
//

import UIKit

enum CellType {
    case sent
    case received
    case groupSent
    case groupReceived
}

class BubbleCell: UITableViewCell {
    
    var message: MessageModel!
    var type: CellType!
    
    convenience init(message: MessageModel!) {
        self.init()
        self.message = message
        self.type = message.type
        
        let bubble = bubbleWith(message: message)
        contentView.addSubview(bubble)
        
        selectionStyle = .none
        prepareGesture()
    }
    
    func bubbleWith(message: MessageModel) -> UIView {
        
        var cornerRadius: CGFloat = 20
        var bubbleWidth: CGFloat = (Metadata.Size.Screen.width / 3.0) * 2.0
        var bubbleHeight: CGFloat = message.content.height(withConstrainedWidth: bubbleWidth-20, font: Metadata.Font.messageFont) + 14
        
        if message.content.containsChineseCharacters {
            if message.content.characters.count < 17 {
                let fooLabel = UILabel(text: message.content)
                fooLabel.font = Metadata.Font.messageFont
                fooLabel.sizeToFit()
                bubbleWidth = fooLabel.bounds.size.width + 20
            }
        } else {
            if message.content.characters.count < 34 {
                //                bubbleWidth = CGFloat(message.content.characters.count) * 8 + 20
                let fooLabel = UILabel(text: message.content)
                fooLabel.font = Metadata.Font.messageFont
                fooLabel.sizeToFit()
                bubbleWidth = fooLabel.bounds.size.width + 20
            }
        }
        
        if bubbleHeight < 50 {
            cornerRadius = bubbleHeight / 3.0
        }
        
        if message.type == .sent {
            
            if message.content.characters.count < 5 && message.content.containsOnlyEmoji {
                let emojiBubble = UILabel(text: message.content, fontSize: 50)
                emojiBubble.sizeToFit()
                bubbleWidth = emojiBubble.bounds.size.width
                bubbleHeight = emojiBubble.bounds.size.height
                //                log.obj(bubbleHeight as AnyObject)/
                emojiBubble.frame = CGRect(x: (Metadata.Size.Screen.width-15-bubbleWidth), y: 0, width: bubbleWidth, height: bubbleHeight)
                return emojiBubble
            }
            
            let bubble = UIImageView(imageName: "BubbleSend", desiredSize: CGSize(width: bubbleWidth, height: bubbleHeight))
            bubble?.layer.cornerRadius = cornerRadius
            bubble?.clipsToBounds = true
            
            bubble?.frame = CGRect(x: (Metadata.Size.Screen.width-15-bubbleWidth), y: 0, width: bubbleWidth, height: bubbleHeight)
            
            //            let messageLabel = UILabel(text: message.content, fontSize: 14)
            //            messageLabel.textColor = .white
            //            messageLabel.numberOfLines = 0
            //            messageLabel.lineBreakMode = .byWordWrapping
            //
            //            messageLabel.frame = CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14)
            //
            //            bubble?.addSubview(messageLabel)
            
            
            // Using better UITextView for special data format detecting
            let messageTextView = UITextView(frame: CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14))
            messageTextView.text = message.content
            if message.content.characters.count < 4 && message.content.containsOnlyEmoji {
                messageTextView.font = Metadata.Font.messageEmojiFont
            } else {
                messageTextView.font = Metadata.Font.messageFont
            }
            
            messageTextView.textColor = .white
            messageTextView.backgroundColor = .clear
            messageTextView.isScrollEnabled = false
            messageTextView.isEditable = false;
//            messageTextView.dataDetectorTypes = .all;
            // Eliminate all the paddings and insets
            messageTextView.textContainerInset = .zero
            messageTextView.textContainer.lineFragmentPadding = 0
            
            bubble?.addSubview(messageTextView)
            return bubble!
            
        } else {
            
            if message.content.characters.count < 5 && message.content.containsOnlyEmoji {
                let emojiBubble = UILabel(text: message.content, fontSize: 50)
                emojiBubble.sizeToFit()
                bubbleWidth = emojiBubble.bounds.size.width
                bubbleHeight = emojiBubble.bounds.size.height
                emojiBubble.frame = CGRect(x: 15, y: 0, width: bubbleWidth, height: bubbleHeight)
                return emojiBubble
            }
            
            let bubble = UIImageView(imageName: "BubbleReceive", desiredSize: CGSize(width: bubbleWidth, height: bubbleHeight))
            bubble?.layer.cornerRadius = cornerRadius
            bubble?.clipsToBounds = true
            
            bubble?.frame = CGRect(x: 15, y: 0, width: bubbleWidth, height: bubbleHeight)
            
            //            let messageLabel = UILabel(text: message.content, fontSize: 14)
            //            messageLabel.textColor = .black
            //            messageLabel.numberOfLines = 0
            //            messageLabel.lineBreakMode = .byWordWrapping
            //
            //            messageLabel.frame = CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14)
            //
            //            bubble?.addSubview(messageLabel)
            
            
            // Using better UITextView for special data format detecting
            let messageTextView = UITextView(frame: CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14))
            messageTextView.text = message.content
            if message.content.characters.count < 4 && message.content.containsOnlyEmoji {
                messageTextView.font = Metadata.Font.messageEmojiFont
            } else {
                messageTextView.font = Metadata.Font.messageFont
            }
            messageTextView.textColor = .black
            messageTextView.backgroundColor = .clear
            messageTextView.isScrollEnabled = false
            messageTextView.isEditable = false;
//            messageTextView.dataDetectorTypes = ;
            // Eliminate all the paddings and insets
            messageTextView.textContainerInset = .zero
            messageTextView.textContainer.lineFragmentPadding = 0
            
            bubble?.addSubview(messageTextView)
            return bubble!
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func prepareGesture() {
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(sender:)))
        longPress.minimumPressDuration = 1
        self.addGestureRecognizer(longPress)
    }
    
    func longPressAction(sender: UILongPressGestureRecognizer) {
        if UIMenuController.shared.isMenuVisible == false {
            self.becomeFirstResponder()
            let copyItem = UIMenuItem(title: "复制", action: #selector(self.customCopy(sender:)))
            UIMenuController.shared.menuItems = [copyItem]
            UIMenuController.shared.setTargetRect(self.frame, in: self.superview!)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(self.customCopy(sender:))
    }
    
    func customCopy(sender: Any?) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = message.content
    }
    
}

//
//  GroupBubbleCellTableViewCell.swift
//  PiperChat
//
//  Created by Allen X on 6/2/17.
//  Copyright © 2017 allenx. All rights reserved.
//

import UIKit

class GroupBubbleCell: UITableViewCell {
    
    var message: MessageModel!
    var type: CellType!
    let avatarView = UIImageView()
    let nameLabel = UILabel(text: "", fontSize: 14)

    convenience init(message: MessageModel) {
        self.init()
        self.message = message
        self.type = message.type
        
        let bubble = bubbleWith(message: message)
        if type == .received {
            
            avatarView.layer.cornerRadius = 17
            avatarView.clipsToBounds = true
            avatarView.frame = CGRect(x: 8, y: 5, width: 34, height: 34)
//            log.word(nameLabel.text!)/
//            nameLabel.textColor = .gray
//            nameLabel.sizeToFit()
//            nameLabel.frame = CGRect(x: 18+39, y: 0, width: nameLabel.bounds.size.width, height: nameLabel.bounds.size.height)
            contentView.addSubview(avatarView)
//            contentView.addSubview(nameLabel)
        }
        
        contentView.addSubview(bubble)
        
        selectionStyle = .none
        prepareGesture()

    }
    
    func bubbleWith(message: MessageModel) -> UIView {
        
        var cornerRadius: CGFloat = 20
        var bubbleWidth: CGFloat = (Metadata.Size.Screen.width / 3.0) * 2.0
        var bubbleHeight: CGFloat = message.content.height(withConstrainedWidth: bubbleWidth-20, font: Metadata.Font.messageFont) + 14
        
        if message.content.containsChineseCharacters {
            if message.content.characters.count < 17 {
                let fooLabel = UILabel(text: message.content)
                fooLabel.font = Metadata.Font.messageFont
                fooLabel.sizeToFit()
                bubbleWidth = fooLabel.bounds.size.width + 20
            }
        } else {
            if message.content.characters.count < 34 {
                //                bubbleWidth = CGFloat(message.content.characters.count) * 8 + 20
                let fooLabel = UILabel(text: message.content)
                fooLabel.font = Metadata.Font.messageFont
                fooLabel.sizeToFit()
                bubbleWidth = fooLabel.bounds.size.width + 20
            }
        }
        
        if bubbleHeight < 50 {
            cornerRadius = bubbleHeight / 3.0
        }
        
        if message.type == .sent {
            
            if message.content.characters.count < 5 && message.content.containsOnlyEmoji {
                let emojiBubble = UILabel(text: message.content, fontSize: 50)
                emojiBubble.sizeToFit()
                bubbleWidth = emojiBubble.bounds.size.width
                bubbleHeight = emojiBubble.bounds.size.height
                //                log.obj(bubbleHeight as AnyObject)/
                emojiBubble.frame = CGRect(x: (Metadata.Size.Screen.width-15-bubbleWidth), y: 0, width: bubbleWidth, height: bubbleHeight)
                emojiBubble.tag = -1

                return emojiBubble
            }
            
            let bubble = UIImageView(imageName: "BubbleSend", desiredSize: CGSize(width: bubbleWidth, height: bubbleHeight))
            bubble?.layer.cornerRadius = cornerRadius
            bubble?.clipsToBounds = true
            
            bubble?.frame = CGRect(x: (Metadata.Size.Screen.width-15-bubbleWidth), y: 0, width: bubbleWidth, height: bubbleHeight)
            
            //            let messageLabel = UILabel(text: message.content, fontSize: 14)
            //            messageLabel.textColor = .white
            //            messageLabel.numberOfLines = 0
            //            messageLabel.lineBreakMode = .byWordWrapping
            //
            //            messageLabel.frame = CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14)
            //
            //            bubble?.addSubview(messageLabel)
            
            
            // Using better UITextView for special data format detecting
            let messageTextView = UITextView(frame: CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14))
            messageTextView.text = message.content
            if message.content.characters.count < 4 && message.content.containsOnlyEmoji {
                messageTextView.font = Metadata.Font.messageEmojiFont
            } else {
                messageTextView.font = Metadata.Font.messageFont
            }
            
            messageTextView.textColor = .white
            messageTextView.backgroundColor = .clear
            messageTextView.isScrollEnabled = false
            messageTextView.isEditable = false;
//            messageTextView.dataDetectorTypes = .;
            // Eliminate all the paddings and insets
            messageTextView.textContainerInset = .zero
            messageTextView.textContainer.lineFragmentPadding = 0
            
            bubble?.addSubview(messageTextView)
            // tag for copy item below
            bubble?.tag = -1
            return bubble!
            
        } else {
            
            if message.content.characters.count < 5 && message.content.containsOnlyEmoji {
                let emojiBubble = UILabel(text: message.content, fontSize: 50)
                emojiBubble.sizeToFit()
                bubbleWidth = emojiBubble.bounds.size.width
                bubbleHeight = emojiBubble.bounds.size.height
                emojiBubble.frame = CGRect(x: 15+39, y: 20, width: bubbleWidth, height: bubbleHeight)
                emojiBubble.tag = -1
                return emojiBubble
            }
            
            let bubble = UIImageView(imageName: "BubbleReceive", desiredSize: CGSize(width: bubbleWidth, height: bubbleHeight))
            bubble?.layer.cornerRadius = cornerRadius
            bubble?.clipsToBounds = true
            
            bubble?.frame = CGRect(x: 15+39, y: 5, width: bubbleWidth, height: bubbleHeight)
            
            //            let messageLabel = UILabel(text: message.content, fontSize: 14)
            //            messageLabel.textColor = .black
            //            messageLabel.numberOfLines = 0
            //            messageLabel.lineBreakMode = .byWordWrapping
            //
            //            messageLabel.frame = CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14)
            //
            //            bubble?.addSubview(messageLabel)
            
            
            // Using better UITextView for special data format detecting
            let messageTextView = UITextView(frame: CGRect(x: 10, y: 7, width: bubbleWidth - 20, height: bubbleHeight - 14))
            messageTextView.text = message.content
            if message.content.characters.count < 4 && message.content.containsOnlyEmoji {
                messageTextView.font = Metadata.Font.messageEmojiFont
            } else {
                messageTextView.font = Metadata.Font.messageFont
            }
            messageTextView.textColor = .black
            messageTextView.backgroundColor = .clear
            messageTextView.isScrollEnabled = false
            messageTextView.isEditable = false;
//            messageTextView.dataDetectorTypes = .all;
            // Eliminate all the paddings and insets
            messageTextView.textContainerInset = .zero
            messageTextView.textContainer.lineFragmentPadding = 0
            
            bubble?.addSubview(messageTextView)
            bubble?.tag = -1
            return bubble!
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    func prepareGesture() {
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(sender:)))
        longPress.minimumPressDuration = 1
        self.addGestureRecognizer(longPress)
    }
    
    func longPressAction(sender: UILongPressGestureRecognizer) {
        if UIMenuController.shared.isMenuVisible == false {
            self.becomeFirstResponder()
            let copyItem = UIMenuItem(title: "复制", action: #selector(self.customCopy(sender:)))
            UIMenuController.shared.menuItems = [copyItem]
            var targetRect: CGRect?
            for view in self.contentView.subviews {
                if view.tag == -1 {
                    targetRect = view.frame
                }
            }
            if let targetRect = targetRect {
//            UIMenuController.shared.setTargetRect(targetRect!, in: self.superview!)
                UIMenuController.shared.setTargetRect(targetRect, in: self)
                UIMenuController.shared.setMenuVisible(true, animated: true)
            }
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(self.customCopy(sender:))
    }
    
    func customCopy(sender: Any?) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = message.content
    }

}

