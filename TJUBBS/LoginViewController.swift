//
//  LoginViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD

class LoginViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var portraitImageView: UIImageView?
    var usernameTextField: UITextField?
    var passwordTextField: UITextField?
    var loginButton: UIButton?
    var registerButton: UIButton?
    var authenticateButton: UIButton?
    var forgetButton: UIButton?
    var visitorButton: UIButton?
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        initUI()
        addTapGestures()
        addKVOSelectors()
        addTargetAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 用户名帮用户输好
        usernameTextField?.text = BBSUser.shared.username

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
            make.height.equalTo(screenSize.height*(650/1920))
        }
        
        usernameTextField = UITextField()
        view.addSubview(usernameTextField!)
        usernameTextField?.snp.makeConstraints {
            make in
            make.top.equalTo(portraitImageView!.snp.bottom).offset(screenSize.height*(100/1920))
            make.centerX.equalToSuperview()
            make.height.equalTo(screenSize.height*(120/1920))
            make.width.equalTo(screenSize.width*(800/1080))
        }
        usernameTextField?.placeholder = "用户名"
        usernameTextField?.clearButtonMode = .whileEditing
        usernameTextField?.borderStyle = .roundedRect
        let usernameLeftView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width*(128/1080), height: screenSize.height*(120/1920)))
        let usernameLeftImageView = UIImageView(image: UIImage(named: "用户名"))
        usernameLeftView.addSubview(usernameLeftImageView)
        usernameLeftImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(screenSize.width*(62/1080))
            $0.height.equalTo(screenSize.height*(57/1920))
        }
        usernameTextField?.leftView = usernameLeftView
        usernameTextField?.leftViewMode = .always
        usernameTextField?.returnKeyType = .next
        usernameTextField?.delegate = self
        usernameTextField?.autocorrectionType = .no
        usernameTextField?.autocapitalizationType = .none
        usernameTextField?.spellCheckingType = .no
        
        passwordTextField = UITextField()
        view.addSubview(passwordTextField!)
        passwordTextField?.snp.makeConstraints {
            make in
            make.top.equalTo(usernameTextField!.snp.bottom).offset(screenSize.height*(56/1920))
            make.centerX.equalToSuperview()
            make.height.equalTo(screenSize.height*(120/1920))
            make.width.equalTo(screenSize.width*(800/1080))
        }
        passwordTextField?.placeholder = "密 码"
        passwordTextField?.borderStyle = .roundedRect
        let passwordLeftView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width*(128/1080), height: screenSize.height*(120/1920)))
        let passwordLeftImageView = UIImageView(image: UIImage(named: "密码"))
        passwordLeftView.addSubview(passwordLeftImageView)
        passwordLeftImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(screenSize.width*(62/1080))
            $0.height.equalTo(screenSize.height*(57/1920))
        }
        passwordTextField?.leftView = passwordLeftView
        passwordTextField?.leftViewMode = .always
        passwordTextField?.returnKeyType = .done
        passwordTextField?.delegate = self
        passwordTextField?.autocorrectionType = .no
        passwordTextField?.autocapitalizationType = .none
        passwordTextField?.spellCheckingType = .no
        passwordTextField?.isSecureTextEntry = true
        
        forgetButton = UIButton(title: "忘记密码?")
        view.addSubview(forgetButton!)
        forgetButton?.snp.makeConstraints {
            make in
            make.top.equalTo(passwordTextField!.snp.bottom).offset(8)
            make.right.equalTo(passwordTextField!.snp.right)
        }
        
        // 这是个好用的方法 欢迎去看我的博客 www.halcao.me/tips-using-block-instead-of-selector-of-uibutton/
        
        forgetButton?.addTarget { _ in
            let vc = InfoModifyController(title: "密码重置", items: ["用户名-输入用户名-username", "学号-输入学号-schoolid", "身份证号-输入身份证号-cid"], style: .bottom, headerMsg: "忘记密码？填写以下信息进行验证") { result in
                // TODO: 判断逻辑
                let vc = InfoModifyController(title: "密码重置", items: ["新密码-输入新密码-newpass-s", "再次确认-输入新密码-ensure-s"], style: .bottom, headerMsg: "验证信息通过，请重置密码") { result in
                    print(result)
                }
                vc.doneText = "确认"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            vc.doneText = "验证"
            self.navigationController?.pushViewController(vc, animated: true)
        }

        loginButton = UIButton(title: "登录", isConfirmButton: true)
        view.addSubview(loginButton!)
        loginButton?.snp.makeConstraints {
            make in
            make.top.equalTo(forgetButton!.snp.bottom).offset(8)
            make.centerX.equalTo(view)
            make.width.equalTo(screenSize.width*(800/1080))
            make.height.equalTo(screenSize.height*(100/1920))
        }
        // 注意这里可能会有循环引用 self->button->block->self.portraitImageView
        loginButton?.addTarget { [weak self] button in
            print("loginButtonTapped")
            if let username = self?.usernameTextField?.text, let password = self?.passwordTextField?.text {
                BBSJarvis.login(username: username, password: password) { dict in
                    if let data = dict["data"] as? [String: AnyObject] {
                        BBSUser.shared.uid = data["uid"] as? Int
                        BBSUser.shared.group = data["group"] as? Int
                        BBSUser.shared.token = data["token"] as? String
                        BBSUser.shared.username = username
                        
                        // 用 UserDefaults 存起来 BBSUser.shared
                        BBSUser.shared.save()
                        HUD.flash(.success, onView: self?.portraitImageView, delay: 1.2, completion: nil)
                        let tabBarVC = MainTabBarController(para: 1)
                        tabBarVC.modalTransitionStyle = .crossDissolve
                        self?.present(tabBarVC, animated: false, completion: nil)

                    }
                }
            }
        }
        
        registerButton = UIButton(title: "新用户注册")
        view.addSubview(registerButton!)
        registerButton?.snp.makeConstraints {
            make in
            make.top.equalTo(loginButton!.snp.bottom).offset(8)
            make.left.equalTo(loginButton!.snp.left)
        }
        
        let check: ([String : String])->(Bool) = { result in
            guard result["repass"] == result["password"] else {
                HUD.flash(.label("两次密码不符！请重新输入👀"), delay: 1.2)
                return false
            }
            return true

        }
        registerButton?.addTarget { _ in
            // FIXME: 密码要求
            let vc =  InfoModifyController(title: "用户注册", items: ["姓名-输入真实姓名-real_name", "学号-输入学号-stunum", "身份证号-输入身份证号-cid", "用户名-6~30字节-username", "密码-8~16位英文/符号/数字-password-s", "再次确认-再次输入密码-repass-s"], style: .bottom, headerMsg: "欢迎新用户！请填写以下信息") { result in
                if let result = result as? [String : String] {
                    if check(result) == true {
                        var para = result
                        para.removeValue(forKey: "repass")
                        BBSJarvis.register(parameters: para) { _ in
                            HUD.flash(.label("注册成功！🎉"), delay: 1.0)
                            BBSUser.shared.username = result["username"]
                            let _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            vc.doneText = "确认"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        authenticateButton = UIButton(title: "老用户认证")
        view.addSubview(authenticateButton!)
        authenticateButton?.snp.makeConstraints {
            make in
            make.top.equalTo(loginButton!.snp.bottom).offset(8)
            make.right.equalTo(loginButton!.snp.right)
        }
        authenticateButton?.addTarget { _ in
            let vc = InfoModifyController(title: "老用户认证", items: ["用户名-输入用户名-username", "姓名-输入姓名-name", "身份证号-输入身份证号-id"], style: .bottom, headerMsg: "老用户（即已拥有BBS账号）请填写以下信息认证") { result in
                print(result)
                // TODO: 逻辑判断
                let vc =  InfoModifyController(title: "老用户认证", items: ["新密码-输入新密码-newpass-s", "再次确认-输入新密码-ensure-s"], style: .bottom, headerMsg: "请重置密码，以同步您的个人数据") { result in
                    print(result)
                }
                vc.doneText = "确认"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            vc.doneText = "验证"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        visitorButton = UIButton(title: "游客登录 >", color: UIColor.BBSBlue, fontSize: 16)
        view.addSubview(visitorButton!)
        visitorButton?.snp.makeConstraints {
            make in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.centerX.equalTo(view)
        }
    }

    func addTapGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func addKVOSelectors() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func addTargetAction() {
        visitorButton?.addTarget(self, action: #selector(visitorButtonTapped), for: .touchUpInside)
    }
    
    func visitorButtonTapped() {
        let tabBarVC = MainTabBarController(para: 1)
        tabBarVC.modalTransitionStyle = .crossDissolve
        self.present(tabBarVC, animated: false, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField?.becomeFirstResponder()
        } else if textField == passwordTextField {
            view.endEditing(true)
            loginButton?.callback(sender: loginButton!)
        }
        return true
    }
}

