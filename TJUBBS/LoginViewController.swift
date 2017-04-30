//
//  LoginViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
class LoginViewController: UIViewController {
    
    let screenFrame = UIScreen.main.bounds
    var portraitImageView: UIImageView?
    var usernameImageView: UIImageView?
    var usernameTextField: UITextField?
    var passwordImageView: UIImageView?
    var passwordTextField: UITextField?
    var loginButton: UIButton?
    var registerButton: UIButton?
    var authenticateButton: UIButton?
    var forgetButton: UIButton?
    var visitorButton: UIButton?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = UIColor.white
        initUI()
        
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
        portraitImageView = UIImageView(image: UIImage(named: "portrait"))
        view.addSubview(portraitImageView!)
        portraitImageView?.snp.makeConstraints {
            make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(screenFrame.height*(650/1920))
        }
        
        usernameImageView = UIImageView(image: UIImage(named: "用户名"))
        view.addSubview(usernameImageView!)
        usernameImageView?.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView!.snp.bottom).offset(screenFrame.height*(100/1920))
            make.left.equalTo(view).offset(screenFrame.width*(150/1080))
            make.width.equalTo(screenFrame.height*(96/1920))
            make.height.equalTo(screenFrame.height*(88/1920))
        }
        
        usernameTextField = UITextField()
        view.addSubview(usernameTextField!)
        usernameTextField?.snp.makeConstraints {
            make in
            make.centerY.equalTo(usernameImageView!)
            make.left.equalTo(usernameImageView!.snp.right).offset(8)
            make.height.equalTo(screenFrame.height*(64/1920))
            make.width.equalTo(screenFrame.width*(650/1080))
        }
        usernameTextField?.placeholder = "用户名"
        
        passwordImageView = UIImageView(image: UIImage(named: "密码"))
        view.addSubview(passwordImageView!)
        passwordImageView?.snp.makeConstraints {
            make in
            make.top.equalTo(usernameImageView!.snp.bottom).offset(screenFrame.height*(100/1920))
            make.left.equalTo(view).offset(screenFrame.width*(150/1080))
            make.width.equalTo(screenFrame.height*(96/1920))
            make.height.equalTo(screenFrame.height*(88/1920))
        }
        
        passwordTextField = UITextField()
        view.addSubview(passwordTextField!)
        passwordTextField?.snp.makeConstraints {
            make in
            make.centerY.equalTo(passwordImageView!)
            make.left.equalTo(passwordImageView!.snp.right).offset(8)
            make.height.equalTo(screenFrame.height*(64/1920))
            make.width.equalTo(screenFrame.width*(650/1080))
        }
        passwordTextField?.placeholder = "密  码"
        
        forgetButton = UIButton()
        view.addSubview(forgetButton!)
        forgetButton?.snp.makeConstraints {
            make in
            make.top.equalTo(passwordImageView!.snp.bottom).offset(8)
            make.right.equalTo(passwordTextField!.snp.right)
        }
        forgetButton?.setTitle("忘记密码?", for: .normal)
        forgetButton?.setTitleColor(UIColor.black, for: .normal)
        forgetButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        loginButton = UIButton(type: .roundedRect)
        view.addSubview(loginButton!)
        loginButton?.snp.makeConstraints {
            make in
            make.top.equalTo(forgetButton!.snp.bottom).offset(8)
            make.centerX.equalTo(view)
            make.width.equalTo(screenFrame.width*(800/1080))
            make.height.equalTo(screenFrame.height*(100/1920))
        }
        loginButton?.setTitle("登 录", for: .normal)
        loginButton?.setTitleColor(UIColor.white, for: .normal)
        loginButton?.backgroundColor = UIColor.init(red: 25.0/255, green: 126.0/255, blue: 225.0/255, alpha: 1.0)
        loginButton?.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginButton?.layer.cornerRadius = 5.0
        loginButton?.clipsToBounds = true
        
        registerButton = UIButton()
        view.addSubview(registerButton!)
        registerButton?.snp.makeConstraints {
            make in
            make.top.equalTo(loginButton!.snp.bottom).offset(8)
            make.left.equalTo(loginButton!.snp.left)
        }
        registerButton?.setTitle("新用户注册", for: .normal)
        registerButton?.setTitleColor(UIColor.black, for: .normal)
        registerButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        authenticateButton = UIButton()
        view.addSubview(authenticateButton!)
        authenticateButton?.snp.makeConstraints {
            make in
            make.top.equalTo(loginButton!.snp.bottom).offset(8)
            make.right.equalTo(loginButton!.snp.right)
        }
        authenticateButton?.setTitle("老用户认证", for: .normal)
        authenticateButton?.setTitleColor(UIColor.black, for: .normal)
        authenticateButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        visitorButton = UIButton()
        view.addSubview(visitorButton!)
        visitorButton?.snp.makeConstraints {
            make in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.centerX.equalTo(view)
        }
        visitorButton?.setTitle("游客登录 >", for: .normal)
        visitorButton?.setTitleColor(UIColor.init(red: 35.0/255, green: 134.0/255, blue: 255.0/255, alpha: 1), for: .normal)
        visitorButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }


}

