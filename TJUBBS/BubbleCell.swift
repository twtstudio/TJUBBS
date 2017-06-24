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
            messageTextView.dataDetectorTypes = .all;
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
            messageTextView.dataDetectorTypes = .all;
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
    
}
