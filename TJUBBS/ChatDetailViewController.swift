//
//  ChatDetailViewController.swift
//  PiperChat
//
//  Created by Allen X on 5/17/17.
//  Copyright © 2017 allenx. All rights reserved.
//

import UIKit
import SlackTextViewController
import PKHUD
import MJRefresh
import Kingfisher

enum ScrollOrientation {
    case up
    case down
    case left
    case right
}

class ChatDetailViewController: SLKTextViewController {
    
    
    var scrollOrientation: ScrollOrientation?
    //    var chatBubbleTable = UITableView()
//    var session: PiperChatSession!
    var pal: UserWrapper?
    var messages: [MessageModel] = []
    var page = 0
    var tableViewLastPosition = CGPoint.zero
    
//    convenience init(session: PiperChatSession) {
//        self.init()
//        self.session = session
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        SocketManager.shared.delegate = self
        
        // TODO: save the draft
        
//        if let messageToSend = UserDefaults.standard.object(forKey: "messageToSendTo\(session.palID)") {
//            textView.text = messageToSend as! String
//        }
        
        // Using SlackTextViewController is funny because my tableView is all inverted by default
//        isInverted = false
        
        tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
//        tableView?.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        (tableView?.mj_header as? MJRefreshNormalHeader)?.lastUpdatedTimeLabel.isHidden = true
        (tableView?.mj_header as? MJRefreshNormalHeader)?.stateLabel.isHidden = true
        
        isInverted = false
        bounces = true
        isKeyboardPanningEnabled = true
        textView.layer.borderColor = UIColor(colorLiteralRed: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0).cgColor
//        textView.placeholder = ""
        textView.placeholderColor = .gray
        
//        textView.backgroundColor = .white
        textView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        textView.layer.borderColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.00).cgColor
        textView.layer.borderWidth = 1
//        textInputbar.editorRightButton.tintColor = Metadata.Color.accentColor
//        textInputbar.rightButton.tintColor = Metadata.Color.accentColor
        textInputbar.isTranslucent = false
        textInputbar.clipsToBounds = true
        textInputbar.autoHideRightButton = false
        textInputbar.maxCharCount = 256
//        textInputbar.leftButton.isHidden = true
        // TODO: send photo
//        leftButton.tintColor = .gray
        rightButton.setTitle("发送", for: .normal)
        
//        session.messages = session.messages
//        title = session.palName
        self.title = pal?.nickname
        
        tableView?.separatorColor = .clear
        
        //TODO: Fix it
        BBSJarvis.getDialog(uid: pal?.uid ?? 0, page: page, success: { messages in
            self.messages = messages
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.scrollToBottom(animated: false)
            }
        })
        scrollToBottom(animated: false)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadMore() {
        page += 1
        BBSJarvis.getDialog(uid: pal?.uid ?? 0, page: page, failure: { error in
            self.page -= 1
            self.tableView?.mj_header.endRefreshing()
        }, success: { messages in
//            self.messages = messages + self.messages
            self.tableView?.mj_header.endRefreshing()
            if messages.count > 0 {
                DispatchQueue.main.async {
                    self.messages = messages + self.messages
                    //                var indexPaths = [IndexPath]()
                    //                for index in 0..<messages.count {
                    //                    indexPaths.append(IndexPath(row: index, section: 0))
                    //                }
                    self.tableView?.reloadData()
                    // scroll to the message above
//                    let index = messages.count < 1 ? messages.count : messages.count - 1
                    let index = messages.count
                    self.tableView?.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // TODO: save the draft

//        if textView.text != "" {
//            // Set the messageToSend cache
//            UserDefaults.standard.set(textView.text, forKey: "messageToSendTo\(session.palID)")
//        } else {
//            UserDefaults.standard.removeObject(forKey: "messageToSendTo\(session.palID)")
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollToBottom(animated: Bool) {
        if tableView?.numberOfRows(inSection: 0) != 0 {
            let indexPath = IndexPath(row: (tableView?.numberOfRows(inSection: 0))!-1, section: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
            //            log.word("scrolled to bottom")/
        }
    }
    
    func prepareTextView() {
        
    }
    
}

//extension ChatDetailViewController: MessageOnReceiveDelegate {
//    func didReceive(message: PiperChatMessage) {
//        if message.type != .groupReceived && message.palID == session.palID {
//            let indexPath = IndexPath(row: messages.count, section: 0)
//            let rowAnimation: UITableViewRowAnimation = .top
//            
//            tableView?.beginUpdates()
//            session.insert(message: message)
//            log.any(session)/
//            tableView?.insertRows(at: [indexPath], with: rowAnimation)
//            
//            tableView?.endUpdates()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//            tableView?.reloadRows(at: [indexPath], with: .automatic)
//        }
//    }
//}

extension ChatDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fooView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 20))
        
        return fooView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fooView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 30))
        
        return fooView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let currentMessage = messages[indexPath.row]
        let messageHeight = currentMessage.content.height(withConstrainedWidth: (Metadata.Size.Screen.width / 3.0) * 2 - 20, font: Metadata.Font.messageFont)

        var bubbleHeight = messageHeight + 14
        
        if currentMessage.content.characters.count < 5 && currentMessage.content.containsOnlyEmoji {
            bubbleHeight = 60
        }
        
        if indexPath.row < messages.count - 1 {
            //Broken because of using SlackTextViewController
            let nextMessage = messages[indexPath.row + 1]
            if nextMessage.type == currentMessage.type {
                bubbleHeight = bubbleHeight + 2
            } else {
                bubbleHeight = bubbleHeight + 8
            }
            
            //            return bubbleHeight + 8
        }
        
        
        return bubbleHeight //+ 15
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging { // ?
            
            if scrollOrientation == .down {
                cell.contentView.layer.transform = CATransform3DMakeTranslation(0, 30, 0)
            } else {
                cell.contentView.layer.transform = CATransform3DMakeTranslation(0, -30, 0)
            }
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.contentView.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        scrollOrientation = scrollView.contentOffset.y > tableViewLastPosition.y ? .down : .up
        
        tableViewLastPosition = scrollView.contentOffset

        let count = tableView!.visibleCells.count
        // (0->index) ---> (0.8->1.0)
        for (index, cell) in (tableView?.visibleCells.enumerated())! {
            cell.alpha = CGFloat(index)*0.25/CGFloat(count)+0.75
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let cell = BubbleCell(message: messages[indexPath.row])
        let message = messages[indexPath.row]
        let cell = GroupBubbleCell(message: message)
        let portraitImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: message.authorId))
        let cacheKey = "\(message.authorId)" + Date.today
        cell.avatarView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        return cell
    }
}


//MARK: TextViewDelegate
extension ChatDetailViewController {
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        scrollToBottom(animated: true)
    }
    
    override func didPressRightButton(_ sender: Any?) {
        
        
        //        let messageToSend = PiperChatMessage(string: textView.text, timestamp: Date().ticks, type: .sent, palID: session.palID)
        let messageToSend = MessageModel(string: textView.text, timestamp: Int(Date().timeIntervalSince1970), type: .sent, palName: pal?.username ?? "", palNickName: pal?.nickname ?? "", palID: pal?.uid ?? 0, id: 0)
        
//        let messageToSend = PiperChatMessage(string: textView.text, timestamp: Date().ticks, type: .sent, palUserName: session.palUserName, palID: session.palID)
        //Send the message via socket and do networking and data storing
        
//
//        session.insert(message: messageToSend)
//        tableView?.insertRows(at: [indexPath], with: rowAnimation)
        
        BBSJarvis.sendMessage(uid: "\(pal?.uid ?? 0)", content: textView.text, failure: { error in
            HUD.flash(.labeledError(title: "发送失败😐请稍后重试", subtitle: ""), delay: 1.0)
        }, success: { dict in
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.messages.count, section: 0)
                let rowAnimation: UITableViewRowAnimation = .top
                
                self.tableView?.beginUpdates()
                self.messages.append(messageToSend)
                //
                //        session.insert(message: messageToSend)
                self.tableView?.insertRows(at: [indexPath], with: rowAnimation)
                self.tableView?.endUpdates()
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.textView.refreshFirstResponder()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            }
            
            print(dict)
        })
        
        
        
//        SocketManager.shared.send(message: messageToSend.content, to: session.palUserName)
        
        
        super.didPressRightButton(sender)
    }
    
}
