//
//  SetInfoViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class SetInfoViewController: UIViewController {
    var tableView: UITableView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑资料"
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SetInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 80
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
                cell.imageView?.image = UIImage(named: "头像")
                let size = CGSize(width: 60, height: 60)
                UIGraphicsBeginImageContext(size)
                let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                cell.imageView?.image?.draw(in: imageRect)
                cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                cell.imageView?.layer.masksToBounds = true
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = "编辑头像"
                return cell
            case 1:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
                cell.textLabel?.text = "昵称"
                // FIXME: 用户名
                cell.detailTextLabel?.text = "jenny"
                cell.accessoryType = .disclosureIndicator
                return cell
            case 2:
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
                cell.textLabel?.text = "签名"
                // FIXME: 用户名
                cell.detailTextLabel?.text = "go big or go home."
                cell.accessoryType = .disclosureIndicator
                return cell
            default:
                break
            }
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "CustomValueCell")
            cell.textLabel?.text = "修改密码"
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                break
                // FIXME: 修改头像
            case 1:
                // FIXME: 旧昵称palceholder
                let vc = InfoModifyController(title: "编辑昵称", items: [" -jenny- -userid"], style: .rightTop) { result in
                    print(result)
                }
                vc.headerMsg = "请输入新昵称"
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = InfoModifyController(title: "编辑签名", style: .custom) { str in
                    print(str)
                }
                let contentView = UIView()
                contentView.backgroundColor = UIColor.white
                let textView = UITextView()
                contentView.addSubview(textView)
                textView.snp.makeConstraints { make in
                    make.top.equalTo(contentView).offset(18)
                    make.left.equalTo(contentView).offset(20)
                    make.right.equalTo(contentView).offset(-20)
                    make.height.equalTo(100)
                }
                textView.layer.borderColor = UIColor.black.cgColor
                textView.layer.borderWidth = 1
                textView.layer.cornerRadius = 3
                textView.text = "go big or go home."
                
                // FIXME: 加载原签名
                let label = UILabel()
                label.text = "18/50字"
                label.font = UIFont.systemFont(ofSize: 13)
                contentView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.top.equalTo(textView.snp.bottom).offset(10)
                    make.right.equalTo(contentView).offset(-20)
                    make.bottom.equalTo(contentView).offset(-10)
                }
                contentView.snp.makeConstraints { make in
                    make.width.equalTo(UIScreen.main.bounds.size.width)
//                    make.height.equalTo(150)
                }
                textView.delegate = vc
                vc.customView = contentView
                vc.customCallback = { count in
                    if let count = count as? Int {
                        label.text = "\(count)/50字"
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                return
            }
        case 1:
            let vc = InfoModifyController(title: "修改密码", items: ["旧密码-请输入旧密码-oldpass-s", "新密码-请输入新密码-newpass-s", "确认密码-请输入新密码-newpass1-s"], style: .rightTop) { result in
                print(result)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}
