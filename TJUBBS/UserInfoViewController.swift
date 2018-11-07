//
//  UserInfoViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher
import ObjectMapper
let MESSAGEKEY = "messageKey"

class UserInfoViewController: UIViewController {
    var tableView = UITableView(frame: .zero, style: .grouped)
    let contentArray = [["我的收藏", "我的发布", "编辑资料"], ["通用设置", "测试界面"]]
    var messagePage: Int = 0
    var messageList: [MessageModel] = []
    var messageFlag = false
    let headerView = UserDetailView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 276))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if BBSUser.shared.isVisitor == false {
//            refreshMessage()
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "个人中心"
        // 导航栏返回按钮文字为空
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refresh))
        self.navigationItem.backBarButtonItem = backItem
        self.navigationItem.rightBarButtonItem = refreshItem

//        scrollViewDidScroll(tableView as UIScrollView)
        refresh()

        let cacheKey = "\(BBSUser.shared.uid ?? 0)"
        if let url = URL(string: BBSAPI.avatar(uid: BBSUser.shared.uid ?? 0)) {
            headerView.avatarView.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default")) { image, _, _, _ in
                BBSUser.shared.avatar = image
            }
            headerView.avatarViewBackground.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default")) { image, _, _, _ in
                BBSUser.shared.avatar = image
            }
        }
        let user = Mapper<UserWrapper>().map(JSON: ["uid": BBSUser.shared.uid ?? "0", "name": BBSUser.shared.username ?? "求实用户", "signature": BBSUser.shared.signature ?? "还没有个性签名", "points": BBSUser.shared.points ?? 0, "c_post": BBSUser.shared.postCount ?? 0, "c_thread": BBSUser.shared.threadCount ?? 0, "t_create": BBSUser.shared.tCreate ?? "fuck"])!
        headerView.loadModel(user: user)
        headerView.setNeedsDisplay()

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            //            make.top.equalToSuperview().offset(-64)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            // Fallback on earlier versions
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "ID")

    }

    func refresh() {
        guard let token = BBSUser.shared.token, token != "" else {
            let alert = UIAlertController(title: "请先登录", message: "BBS需要登录才能查看个人信息", preferredStyle: .alert)
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
        if BBSUser.shared.isVisitor == false {
            BBSJarvis.getHome(success: { wrapper in
                self.headerView.loadModel(user: wrapper)
                self.tableView.reloadData()
            }, failure: { error in
                print(error)
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        self.navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }

}

extension UserInfoViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 && messageFlag == true {
            let cell = UserInfoTableViewCell(iconName: contentArray[indexPath.section][indexPath.row], title: contentArray[indexPath.section][indexPath.row], badgeNumber: 1)
            return cell
        } else {
            let cell = UserInfoTableViewCell(iconName: contentArray[indexPath.section][indexPath.row], title: contentArray[indexPath.section][indexPath.row], badgeNumber: 0)
            return cell
        }
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return screenSize.height*(150/1920)
//    }

}

extension UserInfoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard section == 0 else {
            return nil
        }

        headerView.avatarView.addTapGestureRecognizer { _ in
            let setInfoVC = SetInfoViewController()
            self.navigationController?.pushViewController(setInfoVC, animated: true)
        }

//        // TODO: 称号
//        portraitBadgeLabel = UILabel.roundLabel(text: "一般站友", textColor: .white, backgroundColor: .BBSBadgeOrange)
//        headerView?.addSubview(portraitBadgeLabel!)
//        portraitBadgeLabel?.snp.makeConstraints {
//            make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalTo(avatarBackground.snp.bottom)
//        }
//        portraitBadgeLabel?.alpha = 0

        headerView.threadCountLabel.addTapGestureRecognizer { _ in
            let detailVC = MyPostHomeViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerView.height
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard BBSUser.shared.token != nil else {
            let alert = UIAlertController(title: "请先登录", message: "BBS需要登录才能查看个人信息", preferredStyle: .alert)
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

        switch indexPath {
//        case IndexPath(row: 0, section: 0):
//            let detailVC = MessageViewController(para: 1)
//            messageFlag = false
//            self.navigationController?.pushViewController(detailVC, animated: true)
//        case IndexPath(row: 1, section: 0):
//            let detailVC = FriendsListController(para: 0)
//            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 0, section: 0):
            let detailVC = FavorateViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 1, section: 0):
            let detailVC = MyPostHomeViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 2, section: 0):
            let detailVC = SetInfoViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 0, section: 1):
            let detailVC = SettingViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 1, section: 1):
            let detailVC = NewHomePageViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        default:
            let detailVC = UIViewController()
            detailVC.view.backgroundColor = .white
            detailVC.title = contentArray[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var y = -scrollView.contentOffset.y
//        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
//            //iPhone X
//        } else {
//            y = y - 64
//        }

        guard y > 0 else {
            return
        }
        let ratio = self.view.width/276
        let height = 276 + y
        let width = height*ratio
        headerView.avatarViewBackground.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalTo(width)
            make.centerX.equalTo(headerView.avatarView)
            make.height.equalTo(height+1)
        }
        headerView.frostView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(headerView.avatarView)
            make.width.equalTo(width)
            make.height.equalTo(height+1)
        }
    }
}
