//
//  UserSearchViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/11/22.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

// ashamed to create the class
class UserSearchViewController: UIViewController {
    typealias User = UserWrapper
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var userList: [User] = []
    var doneBlock: ((Int, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        // 设置 searchBar 样式
        searchBar = UISearchBar()
        searchBar.showsScopeBar = true
        searchBar.autocapitalizationType = .none
        searchBar.barTintColor = .white
        //        searchBar.prompt = "搜索"
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        // TODO: shadow
        //        searchBar.layer.shadowOffset = CGSize(width: -4, height: -4)
        //        searchBar.layer.shadowColor = UIColor.black.cgColor
        //        searchBar.layer.shadowRadius = 4
        //        searchBar.layer.masksToBounds = false
        title = "搜索"
        // KVC 注意了 面试一定会问
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.backgroundColor = UIColor(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
            searchField.becomeFirstResponder()
            //            searchField.text = "搜点什么吧！"
        }

        tableView = UITableView(frame: .zero, style: .plain)
        //        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "friendCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
//            make.height.equalTo(40)
        }
        //        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    func search(with keyword: String) {
        guard keyword.count > 0 else {
            return
        }
        BBSJarvis.getUser(by: keyword, failure: { _ in
            HUD.flash(.label("获取用户信息失败..."), delay: 1.2)
        }, success: { userList in
            self.userList = userList
//            self.searchBar.resignFirstResponder()
            self.tableView.reloadData()
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: UISearchBarDelegate
extension UserSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarTextDidEndEditing(searchBar)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
        search(with: searchText)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
        search(with: searchText)
    }
}

// MARK: UITableViewDelegate
extension UserSearchViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        return searchBar
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 100
    //    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = userList[indexPath.row]
        doneBlock?(user.id!, user.username!)
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension UserSearchViewController {
    func keyboardWillHide(notification: Notification) {
//        let height = view.frame.size.height - searchBar.frame.size.height
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }

    func keyboardWillShow(notification: Notification) {
        if let endRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            //, let beginRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue {
//            if beginRect.size.height > 0 && beginRect.origin.y - endRect.origin.y > 0 {
//                let height = view.frame.size.height - searchBar.frame.size.height - endRect.size.height
//                tableView.contentInset.bottom = 300
                tableView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-(endRect.height+20))
                }
//                tableView.frame = CGRect(x: 0, y: searchBar.frame.size.height, width: tableView.frame.size.width, height: height)
//            }
        }
    }
}

// MARK: UITableViewDataSource
extension UserSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! MessageCell
        let model = userList[indexPath.row]

        cell.initUI(portraitImage: nil, username: model.username ?? "好友", time: "0", detail: model.signature ?? "")
        let portraitImage = UIImage(named: "default")
        let url = URL(string: BBSAPI.avatar(uid: model.id ?? 0))
        let cacheKey = "\(model.id ?? 0)"
        cell.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
        cell.timeLabel.isHidden = true
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
}
