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
    var friendList: [UserWrapper] = []

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
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(MessageCell.self, forCellReuseIdentifier: "friendCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView.mj_header.beginRefreshing()
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
        let portraitImage = UIImage(named: "头像2")
        let url = URL(string: BBSAPI.avatar(uid: model.uid ?? 0))
        let cacheKey = "\(model.uid ?? 0)" + Date.today
        cell.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        
        return cell
    }
    
}

extension FriendsListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // present friend dialog
        let detailVC = ChatDetailViewController()
        detailVC.pal = friendList[indexPath.row]
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
