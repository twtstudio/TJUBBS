//
//  AuthenticateViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD

class AuthenticateViewController: UIViewController {
    
    let screenFrame = UIScreen.main.bounds
    var tableView: UITableView?
    var authenticateButton: UIButton?
    var footerView: UIView?
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = UIColor.white
        self.title = "老用户认证"
        UIApplication.shared.statusBarStyle = .lightContent
        initUI()
        addTapGestures()
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
        tableView?.snp.makeConstraints {
            make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(TextInputCell.self, forCellReuseIdentifier: "ID")
    }
    
    func addTapGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    func authenticateButtonTapped() {
        print("func authenticateButtonTapped")
        HUD.flash(.label("验证未通过！请检查信息是否有误"), delay: 1.0)
    }
    
}

extension AuthenticateViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = TextInputCell(title: "用户名", placeholder: "输入用户名")
            return cell
        case 1:
            let cell = TextInputCell(title: "姓名", placeholder: "输入姓名")
            return cell
        case 2:
            let cell = TextInputCell(title: "身份证号", placeholder: "输入身份证号")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenFrame.height*(150/1920)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: screenFrame.height*(120/1920)))
        let textLabel = UILabel(text: "老用户(即已拥有BBS账号)请填写以下信息认证", fontSize: 16)
        headerView.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            make in
            make.left.equalTo(headerView).offset(16)
            make.centerY.equalTo(headerView)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenFrame.height*(120/1920)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: screenFrame.height*(300/1920)))
        authenticateButton = UIButton(title: "验 证", isConfirmButton: true)
        footerView?.addSubview(authenticateButton!)
        authenticateButton?.snp.makeConstraints {
            make in
            make.centerY.equalTo(footerView!)
            make.centerX.equalTo(footerView!)
            make.width.equalTo(screenFrame.width*(800/1080))
            make.height.equalTo(screenFrame.height*(100/1920))
        }
        authenticateButton?.addTarget(self, action: #selector(authenticateButtonTapped), for: .touchUpInside)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return screenFrame.height*(300/1920)
    }
}

extension AuthenticateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? TextInputCell {
            cell.textField?.becomeFirstResponder()
        }
    }
}
