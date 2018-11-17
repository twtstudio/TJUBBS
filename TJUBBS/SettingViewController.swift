//
//  SettingViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    let screenFrame = UIScreen.main.bounds
    var tableView: UITableView?
    var contentArray = ["黑名单", "公开个人资料", "字体设置", "我不想工作！"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通用设置"
        self.hidesBottomBarWhenPushed = true

        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView?.delegate = self
        tableView?.dataSource = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        // This is the better way to hide first headerViews
        self.tableView?.contentInset.top = -35
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return contentArray.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row != 1 && indexPath.row != 3 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = contentArray[indexPath.row]
                return cell
            } else if indexPath.row == 2 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = contentArray[indexPath.row]
                let switchButton = UISwitch()
                cell.contentView.addSubview(switchButton)
                switchButton.onTintColor = UIColor.BBSBlue
                switchButton.snp.makeConstraints {
                    make in
                    make.right.equalToSuperview().offset(-16)
                    make.centerY.equalToSuperview()
                }
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = contentArray[indexPath.row]
                let noWorkSwitchButton = UISwitch()
                cell.contentView.addSubview(noWorkSwitchButton)
                noWorkSwitchButton.onTintColor = UIColor.BBSBlue
                noWorkSwitchButton.snp.makeConstraints {
                    make in
                    make.right.equalToSuperview().offset(-16)
                    make.centerY.equalToSuperview()
                }
                if UserDefaults.standard.bool(forKey: "noJobMode") {
                    noWorkSwitchButton.isOn = true
                } else {
                    noWorkSwitchButton.isOn = false
                }
                noWorkSwitchButton.addTarget(self, action: #selector(noWorkModeOn), for: .valueChanged)
                return cell
            }
        } else if indexPath.section == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
            if let token = BBSUser.shared.token, token != "" {
                cell.textLabel?.text = "退出登录"
            } else {
                cell.textLabel?.text = "马上登录"
            }
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .BBSRed
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            return cell
        }
        return UITableViewCell()
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return screenFrame.height*(150/1920)
//    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let blackListVC = BlackListViewController()
            self.navigationController?.pushViewController(blackListVC, animated: true)
        case IndexPath(row: 2, section: 0):
            let setSizeVC = SetFontSizeViewController()
            self.navigationController?.pushViewController(setSizeVC, animated: true)
//        case IndexPath(row: 3, section: 0):
//            let setSizeVC = MyPostTestViewController()
//            self.navigationController?.pushViewController(setSizeVC, animated: true)
        case IndexPath(row: 0, section: 1):
            BBSJarvis.logout()
            BBSUser.delete()
//            let _ = self.navigationController?.popToRootViewController(animated: false)
            let loginVC = LoginViewController(para: 1)
            let loginNC = UINavigationController(rootViewController: loginVC)
//            if let popoverPresentationController = alertVC.popoverPresentationController {
//                popoverPresentationController.sourceView = cell?.moreButton
//                popoverPresentationController.sourceRect = cell!.moreButton.bounds
//            }
            self.present(loginNC, animated: true, completion: nil)
        default: break
        }
    }
}

extension SettingViewController {
    @objc func noWorkModeOn() {
        if UserDefaults.standard.bool(forKey: "noJobMode") {
            UserDefaults.standard.set(true, forKey: "noJobMode")
        } else {
            UserDefaults.standard.set(false, forKey: "noJobMode")
        }
    }
}
