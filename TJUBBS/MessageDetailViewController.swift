//
//  MessageDetailViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher

class MessageDetailViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var tableView: UITableView?
    var model: MessageModel! = nil
//    let data = [
//        "portrait": "头像2",
//        "sign": "飘飘何所似，天地一沙鸥",
//        "username": "柳永",
//        "label": "陌生人",
//        "detail": "评论了你的帖子:\n寒蝉凄切，对长亭晚，骤雨初歇。都门帐饮无绪，留恋处，兰舟催发。执手相看泪眼，竟无语凝噎。念去去，千里烟波，暮霭沉沉楚天阔。多情自古伤离别，更那堪，冷落清秋节！今宵酒醒何处？杨柳岸，晓风残月。此去经年，应是良辰好景虚设。便纵有千种风情，更与何人说？",
//        "postTitle": "这个时候我就念两句诗",
//        "postAuthor": "不可描述",
//        "authorPortrait": "头像",
//        "time": "1493165223",
//        "authorID": "21148"
//    ]
    var replyView: UIView?
    var replyTextField: UITextField?
    var replyButton: UIButton?
    
    
    convenience init(model: MessageModel) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "详情"
        self.model = model
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
            make.bottom.equalToSuperview().offset(-45)
        }
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        tableView?.allowsSelection = false
        
        replyView = UIView()
        view.addSubview(replyView!)
        replyView?.snp.makeConstraints {
            make in
            make.top.equalTo(tableView!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        replyView?.backgroundColor = .white
        
        replyTextField = UITextField()
        replyView?.addSubview(replyTextField!)
        replyTextField?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(screenSize.width*(820/1080))
            make.bottom.equalToSuperview().offset(-8)
        }
        replyTextField?.borderStyle = .roundedRect
        replyTextField?.returnKeyType = .done
        replyTextField?.delegate = self
        replyTextField?.placeholder = "回复 " + model.authorName

        
        replyButton = UIButton.confirmButton(title: "回复")
        replyView?.addSubview(replyButton!)
        replyButton?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(replyTextField!.snp.right).offset(4)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-8)
        }
        replyButton?.addTarget { _ in
            BBSJarvis.sendMessage(uid: String(self.model.authorId), content: self.replyTextField?.text ?? "", success: { _ in
                self.replyTextField?.text = ""
                HUD.flash(.success)
            })
            self.dismissKeyboard()
        }
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MessageDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = MessageCell()
//            cell.initUI(portraitImage: UIImage(named: data["portrait"]!), username: "\(data["username"]!)[\(data["label"]!)]", time: data["time"]!, detail: data["sign"]!)
            cell.initUI(portraitImage: nil, username: model.authorName, time: String(model.createTime), detail: "")
            let portraitImage = UIImage(named: "头像2")
            
            let url = URL(string: BBSAPI.avatar(uid: model.authorId))
            let cacheKey = "\(model?.authorId ?? 0000)" + Date.today
            cell.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)

            cell.timeLabel.isHidden = true
            return cell
        case 1:
            let cell = UITableViewCell()
            guard let detailedModel = model.detailContent else {
                let detaillabel = UILabel(text: model.content, fontSize: 16)
                cell.contentView.addSubview(detaillabel)
                detaillabel.snp.makeConstraints {
                    make in
                    make.top.equalToSuperview().offset(8)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                }
                detaillabel.numberOfLines = 0
                return cell
            }
            
            let summary = "回复了你:\n" + String.clearBBCode(string: detailedModel.content)
            let detaillabel = UILabel(text: summary, fontSize: 16)
            cell.contentView.addSubview(detaillabel)
            detaillabel.snp.makeConstraints {
                make in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
            detaillabel.numberOfLines = 0
            
            let postLabel = UILabel(text: "原文：")
            cell.contentView.addSubview(postLabel)
            postLabel.snp.makeConstraints {
                make in
                make.top.equalTo(detaillabel.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
            }
            
            let postView = UIImageView(image: UIImage(named: "框"))
            cell.contentView.addSubview(postView)
            postView.snp.makeConstraints {
                make in
                make.top.equalTo(postLabel.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(screenSize.height*(200/1920))
            }
            postView.backgroundColor = .BBSLightGray
            postView.addTapGestureRecognizer(block: { _ in
                print("bang!!!!!")
//                let detailVC = ThreadDetailViewController(thread: )
//                self.navigationController?.pushViewController(detailVC, animated: true)
            })
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(postViewTapped))
//            postView.addGestureRecognizer(tapRecognizer)
//            let portraitImage = UIImage(named: "头像2")
//            let authorPortraitImageView = UIImageView()
//            postView.addSubview(authorPortraitImageView)
//            authorPortraitImageView.snp.makeConstraints {
//                make in
//                make.centerY.equalToSuperview()
//                make.width.height.equalTo(screenSize.width*(160/1080))
//                make.left.equalToSuperview().offset(16)
//            }
//            authorPortraitImageView.layer.cornerRadius = screenSize.width*(160/1080)/2
//            authorPortraitImageView.clipsToBounds = true
//            // TODO: 很晕 这个应该是帖子的作者
//            let url = URL(string: BBSAPI.avatar(uid: model.authorId))
//            let cacheKey = "\(model.authorId)" + Date.today
//            authorPortraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
            

            
            let postTitleLabel = UILabel(text: "主题贴: " + detailedModel.title)
            postView.addSubview(postTitleLabel)
//            postTitleLabel.snp.makeConstraints {
//                make in
//                make.top.equalTo(authorPortraitImageView.snp.top).offset(8)
//                make.left.equalTo(authorPortraitImageView.snp.right).offset(8)
//            }
            postTitleLabel.snp.makeConstraints {
                make in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
            }
            
            // TODO: 获取那篇文章的作者
//            let authorLabel = UILabel(text: "作者: ", color: .darkGray, fontSize: 14)
//            postView.addSubview(authorLabel)
//            authorLabel.snp.makeConstraints {
//                make in
//                make.top.equalTo(postTitleLabel.snp.bottom).offset(8)
//                make.left.equalTo(authorPortraitImageView.snp.right).offset(8)
//                make.right.equalToSuperview().offset(-16)
//            }
            
            let timeString = TimeStampTransfer.string(from: String(detailedModel.createTime), with: "MM-dd")
            let timeLabel = UILabel(text: timeString, color: .lightGray)
            cell.contentView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints {
                make in
                make.top.equalTo(postView.snp.bottom).offset(8)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-8)
            }
            
            //TODO: Input View
            return cell
        default:
            return UITableViewCell()
        }
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

extension MessageDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MessageDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == replyTextField {
            self.dismissKeyboard()
        }
        return true
    }
}

//keyboard layout
extension MessageDetailViewController {
    
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
