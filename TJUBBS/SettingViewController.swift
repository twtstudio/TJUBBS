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
    var contentArray = ["接受陌生人私信", "夜间模式", "公开个人资料"]
    //FIX ME: should initUI in init or viewDidLoad
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "我的收藏"
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView?.delegate = self
        tableView?.dataSource = self
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
        } else if indexPath.section == 1 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
            cell.textLabel?.text = "退出登录"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .BBSRed
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenFrame.height*(150/1920)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 0, section: 1):
            BBSUser.shared.delete()
            let loginVC = LoginViewController(para: 1)
            self.present(loginVC, animated: true, completion: nil)
        default: break
        }
    }
}
