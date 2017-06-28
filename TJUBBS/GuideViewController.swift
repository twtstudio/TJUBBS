//
//  GuideViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/28.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
let GUIDEDIDSHOW = "GuideKey"

class GuideViewController: UIViewController {
    
    var pageControl = UIPageControl()
    var scorllView = UIScrollView()
    let screenSize = UIScreen.main.bounds.size
    let pageNameList = ["启动页1", "启动页2", "启动页3"]
    var newUserButton = UIButton.borderButton(title: "我是新用户")
    var oldUserButton = UIButton.borderButton(title: "我是老用户")
    var loginBtn = UIButton(title: "直接登录>")
//    var loginBtn = UIButton.borderButton(title: "马上体验")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    func initUI() {
        view.addSubview(scorllView)
        scorllView.contentSize = CGSize(width: screenSize.width*CGFloat(pageNameList.count), height: screenSize.height)
        scorllView.showsHorizontalScrollIndicator = false
        scorllView.showsVerticalScrollIndicator = false
        scorllView.scrollsToTop = false
        scorllView.delegate = self
        scorllView.isPagingEnabled = true
        scorllView.bounces = false
        
        for i in 0..<pageNameList.count {
            let imageView = UIImageView(image: UIImage(named: pageNameList[i]))
            imageView.frame = CGRect(x: screenSize.width*CGFloat(i), y: 0, width: screenSize.width, height: screenSize.height)
            scorllView.addSubview(imageView)
        }
        
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .BBSLightGray
        pageControl.currentPageIndicatorTintColor = .BBSBlue
        pageControl.numberOfPages = pageNameList.count
        pageControl.currentPage = 0
        
        
        let check: ([String : String])->(Bool) = { result in
            guard result["repass"] == result["password"] else {
                HUD.flash(.label("两次密码不符！请重新输入👀"), delay: 1.2)
                return false
            }
            return true
        }
        newUserButton.alpha = 0
        newUserButton.addTarget { _ in
            let vc = InfoModifyController(title: "用户注册", items: ["姓名-输入真实姓名-real_name", "学号-输入学号-stunum", "身份证号-身份证号仅用于身份验证-cid", "用户名-2～12个字母-username", "密码-8~16位英文/符号/数字-password-s", "再次确认-再次输入密码-repass-s"], style: .bottom, headerMsg: "欢迎新用户！请填写以下信息", handler: nil)
            vc.handler = { [weak vc] result in
                if let result = result as? [String: String] {
                    if check(result) == true {
                        var para = result
                        para.removeValue(forKey: "repass")
                        BBSJarvis.register(parameters: para) { _ in
                            HUD.flash(.label("注册成功！🎉"), delay: 1.0)
                            BBSUser.shared.username = result["username"]
                            UserDefaults.standard.set(true, forKey: GUIDEDIDSHOW)
                            let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                            vc?.present(navigationController, animated: true, completion: nil)
                        }
                    }
                }
            }
            vc.doneText = "确认"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        oldUserButton.alpha = 0
        oldUserButton.addTarget { _ in
            let veteranCheckVC = InfoModifyController(title: "老用户认证", items: ["老用户名-输入用户名-username", "老密码-输入密码-password-s"], style: .bottom, headerMsg: "老用户登录", handler: nil)
            veteranCheckVC.handler = { [weak veteranCheckVC] result in
                if let result = result as? [String: String] {
                    BBSJarvis.loginOld(username: result["username"]!, password: result["password"]!) {
                        dict in
                        if let status = dict["err"] as? Int, status == 0,
                            let data = dict["data"] as? [String: Any] {
                            HUD.flash(.success)
                            BBSUser.shared.oldToken = data["token"] as? String
                            BBSUser.shared.username = result["username"]
                            let vc =  InfoModifyController(title: "用户注册", items: ["姓名-输入真实姓名-real_name", "身份证号-身份证号仅用于身份验证-cid", "新密码-8~16位英文/符号/数字-password-s", "再次确认-再次输入密码-repass-s"], style: .bottom, headerMsg: "欢迎老用户！请填写以下信息", handler: nil)
                            vc.handler = { [weak vc] result in
                                if let result = result as? [String: String],
                                    check(result) == true {
                                    BBSJarvis.registerOld(username: BBSUser.shared.username!, password: result["password"]!, cid: result["cid"]!, realName: result["real_name"]!) { dict in
                                        if let status = dict["err"] as? Int, status == 0 {
                                            HUD.flash(.success)
                                            UserDefaults.standard.set(true, forKey: GUIDEDIDSHOW)
                                            let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                                            vc?.present(navigationController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                            veteranCheckVC?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            
            
            // 坑人的需求魔改
            let manualView = UILabel(text: "验证遇到问题？点这里")
            manualView.font = UIFont.systemFont(ofSize: 14)
            manualView.addTapGestureRecognizer { _ in
                let manualCheckVC = InfoModifyController(title: "人工验证", items: ["学号-输入学号-stunum", "姓名-输入姓名-realname", "身份证号-身份证号仅用于身份验证-cid", "用户名-输入以前的用户名-username", "邮箱-输入邮箱-mail", "备注-补充说明其他信息证明您的身份，如曾经发过的帖子名、注册时间、注册邮箱、注册时所填住址等-comment-v"], style: .bottom, headerMsg: "老用户（即已拥有BBS账号）请填写以下信息认证", handler: nil)
                // 因为要索引到VC的某个View, 来加载 HUD
                // 注意循环引用
                manualCheckVC.handler = { [weak manualCheckVC] result in
//                    print(result)
                    // TODO: 笑脸的图片
                    if let result = result as? [String: String] {
                        BBSJarvis.appeal(username: result["username"]!, cid: result["cid"]!, realName: result["realname"]!, studentNumber: result["stunum"]!, email: result["mail"]!, message: result["comment"]!) {
                            dict in
                            if let status = dict["err"] as? Int, status == 0 {
                                HUD.flash(.label("验证信息已经发送至后台管理员，验证结果将会在 7 个工作日内发送至您的邮箱，请注意查收~"), delay: 4.0)
                                let _ = manualCheckVC?.navigationController?.popToRootViewController(animated: false)
                            }
                        }
                    }
                }
                manualCheckVC.doneText = "验证"
                self.navigationController?.pushViewController(manualCheckVC, animated: true)
                
            }
            veteranCheckVC.extraView = manualView
            veteranCheckVC.doneText = "验证"
            self.navigationController?.pushViewController(veteranCheckVC, animated: true)
        }
        
        view.addSubview(scorllView)
        scorllView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            make in
            make.bottom.equalToSuperview().offset(-48)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(newUserButton)
        newUserButton.snp.makeConstraints {
            make in
            make.bottom.equalToSuperview().offset(-64)
            make.width.equalTo(screenSize.width*(360/1080))
            make.height.equalTo(screenSize.height*(100/1920))
            make.centerX.equalToSuperview().offset(-screenSize.width/4)
        }
        
        view.addSubview(oldUserButton)
        oldUserButton.snp.makeConstraints {
            make in
            make.bottom.equalToSuperview().offset(-64)
            make.width.equalTo(screenSize.width*(360/1080))
            make.height.equalTo(screenSize.height*(100/1920))
            make.centerX.equalToSuperview().offset(screenSize.width/4)
        }
        
        loginBtn.setTitleColor(UIColor.BBSBlue, for: .normal)
        loginBtn.alpha = 0
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(screenSize.width*(360/1080))
            make.height.equalTo(screenSize.height*(100/1920))
            make.bottom.equalToSuperview().offset(-8)
        }
        loginBtn.addTarget { _ in
            UserDefaults.standard.set(true, forKey: GUIDEDIDSHOW)
            let _ = self.navigationController?.popToRootViewController(animated: false)
            let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
            self.present(navigationController, animated: true, completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    

}

extension GuideViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        pageControl.currentPage = Int(offset.x/screenSize.width)
        
        if pageControl.currentPage == pageNameList.count-1 {
            UIView.animate(withDuration: 0.8, animations: {
                self.newUserButton.alpha = 1
                self.oldUserButton.alpha = 1
                self.loginBtn.alpha = 1
                self.pageControl.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.newUserButton.alpha = 0
                self.oldUserButton.alpha = 0
                self.pageControl.alpha = 1
                self.loginBtn.alpha = 0
            })
        }
    }
}
