//
//  ReplyViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/16.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher
import ObjectMapper

protocol ReplyViewDelegate {
    func didReply()
}

class ReplyViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var tableView: UITableView?
    let data = [
        "portrait": "头像2",
        "sign": "飘飘何所似，天地一沙鸥",
        "username": "柳永",
        "label": "陌生人",
        "detail": "评论了你的帖子:\n寒蝉凄切，对长亭晚，骤雨初歇。都门帐饮无绪，留恋处，兰舟催发。执手相看泪眼，竟无语凝噎。念去去，千里烟波，暮霭沉沉楚天阔。多情自古伤离别，更那堪，冷落清秋节！今宵酒醒何处？杨柳岸，晓风残月。此去经年，应是良辰好景虚设。便纵有千种风情，更与何人说？",
        "postTitle": "这个时候我就念两句诗",
        "postAuthor": "不可描述",
        "authorPortrait": "头像",
        "time": "1493165223"
    ]
    var replyView: UIView?
    var replyTextField: UITextField?
    var replyButton: UIButton?
    var post: PostModel?
    var thread: ThreadModel?
    fileprivate var loadFlag = false
//    var webView = UIWebView()
//    var webViewHeight: CGFloat = 0
    var delegate: ReplyViewDelegate?
    var anonymousView: UIView?
    var anonymousSwitch: UISwitch?
    var anonymousLabel: UILabel?
    
    convenience init(thread: ThreadModel?, post: PostModel?) {
        self.init()
        self.thread = thread
//        print(thread?.boardID)
        self.post = post
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "详情"
        initUI()
        becomeKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    func initUI() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints {
            make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 250
        tableView?.allowsSelection = false
        
        replyView = UIView()
        view.addSubview(replyView!)
        replyView?.snp.makeConstraints {
            make in
            make.top.equalTo(tableView!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        replyView?.backgroundColor = .white
        
        anonymousLabel = UILabel()
        replyView?.addSubview(anonymousLabel!)
        anonymousLabel?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
        }
        if thread?.boardID == 193 {
            anonymousLabel?.text = "匿名"
        } else {
            anonymousLabel?.text = "匿名不可用"
        }
        
        anonymousSwitch = UISwitch()
        anonymousSwitch?.onTintColor = .BBSBlue
        replyView?.addSubview(anonymousSwitch!)
        anonymousSwitch?.snp.makeConstraints {
            make in
            make.centerY.equalTo(anonymousLabel!)
            make.right.equalToSuperview().offset(-16)
        }
        if thread?.boardID == 193 {
            anonymousSwitch?.isEnabled = true
        } else {
            anonymousSwitch?.isEnabled = false
        }
        
        replyTextField = UITextField()
        replyView?.addSubview(replyTextField!)
        replyTextField?.snp.remakeConstraints {
            make in
            make.top.equalTo(anonymousLabel!.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(screenSize.width*(820/1080))
            make.bottom.equalToSuperview().offset(-8)
        }
        replyTextField?.borderStyle = .roundedRect
        replyTextField?.returnKeyType = .done
        replyTextField?.delegate = self
        replyTextField?.placeholder = post != nil ? "回复 #\(post!.floor) \(post!.authorName) 的帖子" : nil
        
        replyButton = UIButton.confirmButton(title: "回复")
        replyView?.addSubview(replyButton!)
        replyButton?.snp.remakeConstraints {
            make in
            make.top.equalTo(anonymousSwitch!.snp.bottom).offset(8)
            make.left.equalTo(replyTextField!.snp.right).offset(4)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-8)
        }
        replyButton?.addTarget(withBlock: {_ in
            
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "BBS需要登录才能发布消息", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "好的", style: .default) {
                    _ in
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    self.present(navigationController, animated: true, completion: nil)
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let text = self.replyTextField?.text, text != "" {
                // 添加回复
                let noBBtext = text.replacingOccurrences(of: "[", with: "&#91;").replacingOccurrences(of: "]", with: "&#93;")
                // TODO: 回复内容修正
                var reply = noBBtext
                if let post = self.post {
                    var refText = post.content
                    if post.content.characters.count >= 50 {
                        // cut it down
                        refText = post.content.substring(to: post.content.index(post.content.startIndex, offsetBy: 50)) + "\n..."
                    }
                    // FIXME:  回复markdown模版
                    reply = noBBtext + "\n>回复 #\(post.floor) \(post.authorName): \n\(refText)\n\n"
                }
                
                BBSJarvis.reply(threadID: self.thread!.id, content: reply, toID: self.post?.id, anonymous: self.anonymousSwitch?.isOn ?? false, success: {
                    dict in
                    print(dict)
                    HUD.flash(.success)
                    self.replyTextField?.text = ""
                    self.delegate?.didReply()
                    let _ = self.navigationController?.popViewController(animated: true)
                })
                self.dismissKeyboard()
            } else {
                HUD.flash(.label("内容不能为空"))
            }
        })
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ReplyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func prepareReplyCellForIndexPath(tableView: UITableView, indexPath: IndexPath, post: PostModel) -> RichPostCell {
        let cell = RichPostCell(reuseIdentifier: "RichReplyCell")
        cell?.hasFixedRowHeight = false
        cell?.delegate = self
        cell?.selectionStyle = .none
        cell?.load(post: post)
//        cell?.initUI(post: post)
        cell?.attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell?.attributedTextContextView.shouldDrawImages = true
        cell?.attributedTextContextView.setNeedsLayout()
        cell?.attributedTextContextView.layoutIfNeeded()
        cell?.contentView.setNeedsLayout()
        cell?.contentView.layoutIfNeeded()

        let url = URL(string: BBSAPI.avatar(uid: thread!.authorID))
        let cacheKey = "\(post.authorID)" + Date.today
        cell?.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return prepareReplyCellForIndexPath(tableView: tableView, indexPath: indexPath, post: post!)
    }
    
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //    func postViewTapped() {
    //        let detailVC = PostDetailViewController(para: 1)
    //        self.navigationController?.pushViewController(detailVC, animated: true)
    //    }
    
}

extension ReplyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ReplyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == replyTextField {
            textField.text = ""
            self.dismissKeyboard()
        }
        return true
    }
}

//keyboard layout
extension ReplyViewController {
    
    override func becomeKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        //        print("用的是我，口亨～")
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo  = notification.userInfo! as Dictionary
        let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyboardBounds.size.height
        let animations:(() -> Void) = {
            self.replyView?.transform = CGAffineTransform(translationX: 0, y: -deltaY)
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let userInfo  = notification.userInfo! as Dictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            self.replyView?.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
}


extension ReplyViewController: HtmlContentCellDelegate {
    func htmlContentCell(cell: RichPostCell, linkDidPress link: URL) {
        print("tapped")
        print(link)
    }

    func htmlContentCellSizeDidChange(cell: RichPostCell) {
        self.tableView?.reloadData()
    }
}
