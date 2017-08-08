//
//  MessageViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher
import ObjectMapper
import MJRefresh
import PKHUD

class MessageViewController: UIViewController {
    
    var tableView: UITableView?
    var msgList: [MessageModel] = [] {
        didSet {
            var authorIDs: [Int] = [] // exclude the same authorID
            msgList = msgList.filter { msg in
                for username in BBSUser.shared.blackList.keys {
                    if username == msg.authorName {
                        return false
                    }
                }
                if msg.friendRequest != nil {
                    return true
                } else if msg.detailContent == nil { // simple Post Message(PM): so-called "站内信"
                    if authorIDs.contains(msg.authorId) {
                        return false
                    } else {
                        authorIDs.append(msg.authorId)
                        return true
                    }
                } else { // system message or so // detailed
                    return true
                }
            }
        }
    }
    var page: Int = 0
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "我的消息"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //        guard msgList.count != 0 else {
        //            let noDataLabel = UILabel(text: "没有消息哦～", color: .gray, fontSize: 20)
        //            view.addSubview(noDataLabel)
        //            noDataLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        //            return
        //        }
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(108)
            make.left.right.bottom.equalToSuperview()
        }
        tableView?.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        
//        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        let header = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        var refreshingImages = [UIImage]()
        for i in 1...6 {
            let image = UIImage(named: "鹿鹿\(i)")?.kf.resize(to: CGSize(width: 60, height: 60))
            refreshingImages.append(image!)
        }
        header?.setImages(refreshingImages, duration: 0.2, for: .pulling)
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setImages(refreshingImages, for: .pulling)
        tableView?.mj_header = header

        
        self.tableView?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        self.tableView?.mj_footer.isAutomaticallyHidden = true
        self.tableView?.mj_header.beginRefreshing()
    }
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        let model = msgList[indexPath.row]
        var content = model.content
        if let detail = model.detailContent {
            content = detail.content
        }
        if model.detailContent != nil {
            cell.initUI(portraitImage: nil, username: model.authorName, time: String(model.createTime), detail: ("回复了你: "+content))
        } else if model.friendRequest != nil {
            cell.initUI(portraitImage: nil, username: model.authorName, time: String(model.createTime), detail: ("好友申请: " + model.friendRequest!.message))
        } else {
            cell.initUI(portraitImage: nil, username: model.authorName, time: String(model.createTime), detail: (content))
        }
        let portraitImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: model.authorId))
        let cacheKey = "\(model.authorId)" + Date.today
        cell.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        if model.authorId != 0 { // exclude anonymous user
            cell.portraitImageView.addTapGestureRecognizer { _ in
                let userVC = UserDetailViewController(uid: model.authorId)
                self.navigationController?.pushViewController(userVC, animated: true)
            }
        }
        return cell
    }
    
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = msgList[indexPath.row]
        if model.friendRequest != nil {
            let detailVC = MessageDetailViewController(model: msgList[indexPath.row])
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else if model.detailContent == nil { // simple Post Message(PM): so-called "站内信"
            let dialogVC = ChatDetailViewController()
            let pal = UserWrapper(JSONString: "{\"uid\": \(model.authorId) ,\"username\": \"\(model.authorName)\", \"nickname\": \"\(model.authorNickname)\"}")
            dialogVC.pal = pal
            self.navigationController?.pushViewController(dialogVC, animated: true)
        } else {
            let detailVC = MessageDetailViewController(model: msgList[indexPath.row])
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

}


extension MessageViewController {
    func refresh() {
        self.page = 0
        BBSJarvis.getMessage(page: page, failure: { _ in
            if (self.tableView?.mj_header.isRefreshing())! {
                self.tableView?.mj_header.endRefreshing()
            }
        }, success: { list in
            self.msgList = list.count == 0 ? self.msgList : list
            self.tableView?.reloadData()
            if (self.tableView?.mj_header.isRefreshing())! {
                self.tableView?.mj_header.endRefreshing()
            }
//            if self.msgList.count < 49 {
//                self.tableView?.mj_footer.endRefreshingWithNoMoreData()
//            } else {
//                self.tableView?.mj_footer.resetNoMoreData()
//            }
        })
        self.tableView?.reloadData()
    }
    
    func load() {
        self.page += 1
        BBSJarvis.getMessage(page: page, failure: { _ in
            if (self.tableView?.mj_footer.isRefreshing())! {
                self.tableView?.mj_footer.endRefreshing()
            }
        }, success: { list in
            self.msgList += list
            self.tableView?.reloadData()
            if (self.tableView?.mj_footer.isRefreshing())! {
                self.tableView?.mj_footer.endRefreshing()
            }
        })
        self.tableView?.reloadData()
    }
}
