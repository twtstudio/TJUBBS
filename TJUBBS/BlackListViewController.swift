//
//  BlackListViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher

class BlackListViewController: UIViewController {
    var tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    let containerView = UIView()
    var blackList: [String: Int] {
            return BBSUser.shared.blackList
    }
    var names: [String] {
        return Array<String>(blackList.keys)
    }

    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
    }

    func checkEmpty() {
        if names.count == 0 {
            let label = UILabel()
            label.text = "这里空空的"
            label.textColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
            label.font = UIFont.boldSystemFont(ofSize: 19)
            containerView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(containerView)
                make.centerX.equalTo(containerView)
            }
            containerView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
            label.sizeToFit()
            self.view.addSubview(containerView)
            containerView.frame = CGRect(x: 0, y: 60, width: self.view.width, height: 40)
            containerView.sizeToFit()
        }
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
        tableView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        // 把返回换成空白
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.title = "黑名单"
        checkEmpty()
    }
}

extension BlackListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let username = names[indexPath.row]
        let uid = blackList[username] ?? 0

        let avatarView = UIImageView()
        cell.contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-8)
        }
        avatarView.layer.cornerRadius = 6
        avatarView.layer.masksToBounds = true

        let usernameLabel = UILabel(text: (username), fontSize: 19)
        cell.contentView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(8)
            make.centerY.equalTo(avatarView.snp.centerY)
        }

        let deleteButton = UIButton()
        cell.contentView.addSubview(deleteButton)
        deleteButton.addTarget { _ in
            self.tableView.beginUpdates()
            BBSUser.shared.blackList.removeValue(forKey: username)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            self.tableView.reloadData()
            BBSUser.save()
            self.checkEmpty()
        }
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(25)
            make.centerY.equalTo(avatarView.snp.centerY)
        }

        let portraitImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: uid))
        let cacheKey = "\(uid)" + Date.today
        avatarView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        return cell
    }

}

extension BlackListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
