//
//  FriendsListController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/6/24.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher
import ObjectMapper
import MJRefresh
import PKHUD

class FriendsListController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size

    var tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    var containerView = UIView()
    var friendList: [UserWrapper] = [] {
        didSet {
            if friendList.count > 0 && containerView.superview != nil {
                containerView.removeFromSuperview()
            } else if friendList.count == 0 && containerView.superview == nil {
                if containerView.subviews.count == 0 {
                    let label = UILabel()
                    label.text = "还没有好友 快去找小伙伴聊天吧!"
                    label.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
                    label.font = UIFont.boldSystemFont(ofSize: 19)
                    containerView.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.centerY.equalTo(containerView)
                        make.centerX.equalTo(containerView)
                    }
                    label.sizeToFit()
                }
                containerView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
                self.view.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 60, width: self.view.width, height: 40)
                containerView.sizeToFit()
            }
        }
    }
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "好友"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
//        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(MessageCell.self, forCellReuseIdentifier: "friendCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView.mj_header.beginRefreshing()
        tableView.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(108)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let pal = friendList[indexPath.row]
        friendList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        BBSJarvis.friendRemove(uid: pal.uid ?? 0, failure: { _ in
            
        }, success: { _ in
        
        })
    }

}

extension FriendsListController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! MessageCell
        let model = friendList[indexPath.row]
        
        cell.initUI(portraitImage: nil, username: model.username ?? "好友", time: "0", detail: model.signature ?? "")
        let portraitImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: model.uid ?? 0))
        let cacheKey = "\(model.uid ?? 0)" + Date.today
        cell.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        cell.timeLabel.isHidden = true
        if model.uid != 0 { // exclude anonymous user
            cell.portraitImageView.addTapGestureRecognizer { _ in
                let userVC = HHUserDetailViewController(uid: model.uid ?? 0)
                self.navigationController?.pushViewController(userVC, animated: true)
            }
        }
        return cell
    }
    
}

extension FriendsListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // present friend dialog
        let detailVC = ChatDetailViewController()
        detailVC.pal = friendList[indexPath.row]
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

}


extension FriendsListController {
    func refresh() {
        BBSJarvis.getFriendList(failure: { _ in
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }

        }, success: { friends in
            self.friendList = friends
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.tableView.mj_header.isRefreshing() {
                    self.tableView.mj_header.endRefreshing()
                }
            }
        })
    }
}
