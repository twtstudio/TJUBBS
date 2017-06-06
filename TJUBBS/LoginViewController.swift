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
let EULACONFIRMKEY = "ConfirmEULA"

class LoginViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var portraitImageView: UIImageView?
    var usernameTextField: UITextField?
    var passwordTextField: UITextField?
    var loginButton: UIButton?
    var registerButton: UIButton?
    var authenticateButton: UIButton?
    var registerGuideButton: UIButton?
    var forgetButton: UIButton?
    var visitorButton: UIButton?
    var EULATitleLabel: UILabel?
    var EULATextView: UITextView?
    var EULABackground: UIView?
    var EULAConfirmButton: UIButton?
    var EULACancelButton: UIButton?
    var EULAShowButton: UIButton?
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        becomeKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
        
        EULATitleLabel = UILabel(text: "用户许可协议", color: .BBSBlue, fontSize: 16)
        EULABackground = UIView()
        EULATextView = UITextView()
        EULAConfirmButton = UIButton(title: "同意", color: .BBSBlue)
        EULACancelButton = UIButton(title: "关闭", color: .BBSRed)
        
        EULABackground?.addSubview(EULATitleLabel!)
        EULABackground?.addSubview(EULATextView!)
        EULABackground?.addSubview(EULACancelButton!)
        EULABackground?.addSubview(EULAConfirmButton!)
        view.addSubview(EULABackground!)
        
        
        //TODO: Better UI
        EULABackground?.snp.makeConstraints {
            make in
            make.top.left.equalToSuperview().offset(24)
            make.bottom.right.equalToSuperview().offset(-24)
        }
        EULATitleLabel?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        EULATextView?.snp.makeConstraints {
            make in
            make.top.equalTo(EULATitleLabel!.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        EULAConfirmButton?.snp.makeConstraints {
            make in
            make.top.equalTo(EULATextView!.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset((screenSize.width-48)/4)
            make.bottom.equalToSuperview().offset(-16)
        }
        EULACancelButton?.snp.makeConstraints {
            make in
            make.top.equalTo(EULATextView!.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(-(screenSize.width-48)/4)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        EULABackground?.backgroundColor = .BBSLightGray
        EULABackground?.alpha = 0
        EULABackground?.layer.cornerRadius = 5.0
        EULABackground?.clipsToBounds = true
        var content = ""
        content += "求实BBS用户协议\n"
        content += "\n"
        content += "欢迎您注册求实BBS账号。求实BBS开发者，对“求实BBS”所提供的站点、APP等服务进行开发、维护和运营。在您使用“求实BBS”提供的服务之前，应当知晓并同意本协议的全部内容。\n"
        content += "\n"
        content += "一 协议的适用范围\n"
        content += "\n"
        content += "当您以任何方式使用求实BBS提供的服务（所属求实BBS的网站、APP）时，适用本协议。\n"
        content += "\n"
        content += "二 账号信息管理\n"
        content += "\n"
        content += "2.1 求实BBS账号是您在求实BBS相关服务中的唯一用户标识。在您使用求实BBS提供的部分服务时，需要注册求实BBS账号。\n"
        content += "2.2 只有天津大学的学生（包括在读或毕业的专、本、硕、博学生）和教工才能注册求实BBS账号。注册时，需要提供您的学/工号（新生可使用通知书号）和身份证号，系统将与从学校获取的信息进行比对，并将您的账号与您的身份绑定。\n"
        content += "2.3 您应当妥善保管求实BBS账号对应的用户名、密码以及所关联的邮箱、第三方账号。因上述内容丢失而导致的账号被盗或丢失责任由您个人承担。\n"
        content += "2.4 求实BBS保证，在得到您的允许之前，仅将您的邮箱用于账号安全（如：密码重置、安全验证）及必要的通知。\n"
        content += "2.5 如遇相关法律法规或法院、政府机关要求，求实BBS可能会将您的部分或全部信息提供给相关部门。\n"
        content += "\n"
        content += "三 用户内容管理\n"
        content += "\n"
        content += "3.1 您在使用求实BBS提供的服务时，不得以任何形式提交或发布包含下列内容的信息：\n"
        content += "(1) 反对宪法所确定的基本原则的；\n"
        content += "(2) 危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n"
        content += "(3) 损害国家荣誉和利益的；\n"
        content += "(4) 煽动民族仇恨、民族歧视，破坏民族团结的；\n"
        content += "(5) 破坏国家宗教政策，宣扬邪教和封建迷信的；\n"
        content += "(6) 散布谣言，扰乱社会秩序，破坏社会稳定的；\n"
        content += "(7) 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n"
        content += "(8) 侮辱或者诽谤他人，侵害他人合法权益的；\n"
        content += "(9) 泄露商业机密或国家机密，或侵害他人知识产权的；\n"
        content += "(10) 含有法律、行政法规禁止的其他内容的；\n"
        content += "3.2 您不能使用下列内容作为 用户名、头像 等展示信息：\n"
        content += "(1) 现实存在的 国家/地区/党派/团体/企业/机构 的名称、旗帜或相关的徽章、图标（已获得授权的除外）；\n"
        content += "(2) 现实存在的 国家/地区/党派/团体/企业/机构 的知名成员的姓名、照片、签名；\n"
        content += "(3) 容易引起争议的内容（包括但不限于主权争议、归属争议等）；\n"
        content += "(4) 不文明（包括但不限于暴力、性暗示等）的文字、图片；\n"
        content += "(5) 违反法律法规的内容（包括但不限于非法广告、恶意链接等）。\n"
        content += "3.3 您不得以任何方式、任何形式进行下列任何活动：\n"
        content += "(1) 盗用或冒用求实BBS官方身份；\n"
        content += "(2) 攻击求实BBS的服务及相关服务；\n"
        content += "(3) 取得不当利益或盗取他人信息；\n"
        content += "(4) 存储/展示/传播 病毒或恶意代码；\n"
        content += "(5) 无故消耗服务器资源\n"
        content += "3.4 您理解并同意，求实BBS有权对上述相关违规行为进行独立判断，在不预先通知的情况下采取包括但不限于对相关内容进行屏蔽、删除或对您的求实BBS账号进行封停、删除等措施，并保留上报有关部门的权利。且可能由此造成的一切后果由您个人承担。\n"
        content += "3.5 未经求实BBS的授权或许可，您不得借用求实BBS的名义从事任何商业活动，也不得将求实BBS提供的平台作为从事商业活动的场所、平台或其他任何形式的媒介。禁止将求实BBS用作从事各种非法活动的场所、平台或者其他任何形式的媒介。\n"
        content += "\n"
        content += "四 权利说明\n"
        content += "\n"
        content += "4.1 求实BBS所提供的各项服务，如无特殊声明，相关设计、程序的所有权归求实BBS工作室所有（引用组件除外）。未经授权，不得仿制。\n"
        content += "4.2 由用户发布的任何信息，除本协议另有声明的情况下，所有的权利及义务均属于发布者。求实BBS及其他用户不对其内容或可能产生的任何后果承担任何责任。\n"
        content += "4.3 在不以营利为目的的前提下，求实BBS可以对用户提交的内容进行整合、汇编并公开发布。发布时应当注明原作者。\n"
        content += "\n"
        content += "五 责任免除\n"
        content += "\n"
        content += "5.1 您理解并同意，求实BBS的服务是按照现有技术和条件所能达到的现状提供的。求实BBS会尽最大努力向您提供服务，但不保证服务随时可用。\n"
        content += "5.2 您理解并同意，求实BBS所提供的服务可能会包含用户或其他第三方提供的内容。求实BBS无法预知这些内容的实际情况，且不对这些信息的真实性或有效性提供担保。对于用户经上述内容取得的任何产品、信息或资料，求实BBS不承担任何责任，需由用户自行负担风险。\n"
        content += "5.3 您理解并同意，在使用求实BBS的服务时，您的网络连接可能会受到第三方（包括但不限于网络服务商、政府机关以及可能的攻击者等）的监听、审查或干扰（包括但不限于插入广告、推送信息、劫持连接和中断访问等）。求实BBS对因此导致的影响不承担责任。\n"
        content += "5.4 您理解并同意，如遇下列情况导致服务出现中断或终止，求实BBS对因此导致的影响不承担责任：\n"
        content += "(1) 遇到不可抗力等因素（包括但不限于自然灾害如洪水、地震、瘟疫流行和风暴等以及社会事件如战争、动乱、政府行为等）；\n"
        content += "(2) 由于第三方过错导致的服务中断（包括但不限于服务提供商过错等）；\n"
        content += "(3) 由于服务遭受攻击或受到病毒、木马等恶意程序影响的；\n"
        content += "(4) 其它应当免除求实BBS之责任的情形。\n"
        content += "\n"
        content += "六 协议生效\n"
        content += "\n"
        content += "6.1 本协议最终解释权归求实BBS工作室所有，求实BBS工作室有权在不进行通知的情况下修改服务协议。\n"
        content += "6.2 本协议未尽事宜，依照中华人民共和国相关法律法规处理。\n"
        content += "6.3 无论因何种原因导致本协议中部分无效或不可执行，其余条款仍对双方有效。\n"
        content += "6.4 本协议中所有标题仅作索引使用，不能作为解释协议内容的依据。"
        EULATextView?.text = content
        EULATextView?.isEditable = false
        
        
        EULACancelButton?.addTarget(withBlock: { _ in
            UIView.animate(withDuration: 0.8, animations: {
                self.EULABackground?.frame.origin.y = -self.screenSize.height
            }, completion: {
                _ in
                self.EULABackground?.alpha = 0
            })
        })
        
        EULAConfirmButton?.addTarget(withBlock: { _ in
            UIView.animate(withDuration: 0.8, animations: {
                self.EULABackground?.frame.origin.y = -self.screenSize.height
            }, completion: {
                _ in
                self.EULABackground?.alpha = 0
            })
            UserDefaults.standard.set(true, forKey: EULACONFIRMKEY)
            self.loginButton?.isEnabled = true
            self.visitorButton?.isEnabled = true
        })
        
//        UserDefaults.standard.removeObject(forKey: EULACONFIRMKEY)
        let EULAKey = UserDefaults.standard.value(forKey: EULACONFIRMKEY) as? Bool
        if EULAKey == nil || EULAKey == false {
            EULABackground?.alpha = 1
        }
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
        portraitImageView = UIImageView(image: UIImage(named: "启动页0"))
        view.addSubview(portraitImageView!)
        portraitImageView?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(screenSize.height*(650/1920)-667)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(screenSize.height)
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
        
        let check: ([String : String])->(Bool) = { result in
            guard result["repass"] == result["password"] else {
                HUD.flash(.label("两次密码不符！请重新输入👀"), delay: 1.2)
                return false
            }
            return true
        }
        
        // 这是个好用的方法 欢迎去看我的博客 www.halcao.me/tips-using-block-instead-of-selector-of-uibutton/
        
        
        forgetButton?.addTarget { _ in
            let vc = InfoModifyController(title: "密码重置", items: ["用户名-输入用户名-username", "学号-输入学号-schoolid", "真实姓名-输入真实姓名-realname", "身份证号-身份证号仅用于身份验证-cid"], style: .bottom, headerMsg: "忘记密码？填写以下信息进行验证", handler: nil)
            vc.handler =  { [weak vc] result in
                if let result = result as? [String: String] {
                    print(result)
                    if check(result) == true {
                        BBSJarvis.retrieve(stunum: result["schoolid"]!, username: result["username"]!, realName: result["realname"]!, cid: result["cid"]!) {
                            dict in
                            if let data = dict["data"] as? [String: Any] {
                                BBSUser.shared.uid = data["uid"] as? Int
                                BBSUser.shared.resetPasswordToken = data["token"] as? String
                                HUD.flash(.success)
                                let resetVC = InfoModifyController(title: "密码重置", items: ["新密码-输入新密码-newpass-s", "再次确认-输入新密码-ensure-s"], style: .bottom, headerMsg: "验证信息通过，请重置密码", handler: nil)
                                resetVC.handler = { [weak resetVC] result in
                                    if let result = result as? [String: String] {
                                        BBSJarvis.resetPassword(password: result["newpass"]!) {
                                            dict in
                                            resetVC?.navigationController?.popToRootViewController(animated: false)
                                        }
                                    }
                                }
                                resetVC.doneText = "确认"
                                vc?.navigationController?.pushViewController(resetVC, animated: true)
                            }
                        }
                    }
                }
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
        if let EULAKey = UserDefaults.standard.value(forKey: EULACONFIRMKEY) as? Bool, EULAKey == true {
            loginButton?.isEnabled = true
        } else {
            loginButton?.isEnabled = false
        }
        // 注意这里可能会有循环引用 self->button->block->self.portraitImageView
        loginButton?.addTarget { [weak self] button in
            //            print("loginButtonTapped")
            
            if let username = self?.usernameTextField?.text, let password = self?.passwordTextField?.text, username != "", password != "" {
                HUD.show(.rotatingImage(#imageLiteral(resourceName: "progress")))
                BBSJarvis.login(username: username, password: password) {
                    HUD.hide()
                    HUD.flash(.success, onView: self?.portraitImageView, delay: 1.2, completion: nil)
                    BBSUser.shared.isVisitor = false
                    let tabBarVC = MainTabBarController(para: 1)
                    tabBarVC.modalTransitionStyle = .crossDissolve
                    self?.present(tabBarVC, animated: false, completion: nil)
                }
            } else {
                HUD.flash(.label("用户名或密码不能为空"), onView: self?.view, delay: 0.7, completion: nil)
            }
        }
        
        EULAShowButton = UIButton(title: "《用户许可协议》", color: .BBSBlue, fontSize: 16)
        view.addSubview(EULAShowButton!)
        EULAShowButton?.snp.makeConstraints {
            make in
            make.top.equalTo(loginButton!.snp.bottom).offset(8)
            make.centerX.equalToSuperview().offset(24)
        }
        EULAShowButton?.addTarget(withBlock: { _ in
            self.EULABackground?.alpha = 1
            UIView.animate(withDuration: 0.8, animations: {
                self.EULABackground?.frame.origin.y = 24
            })
        })
        
        let pleaseLabel = UILabel(text: "请同意", color: .black, fontSize: 16)
        view.addSubview(pleaseLabel)
        pleaseLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(EULAShowButton!)
            make.right.equalTo(EULAShowButton!.snp.left)
        }
        
        registerButton = UIButton(title: "新用户注册")
        view.addSubview(registerButton!)
        registerButton?.snp.makeConstraints {
            make in
            make.top.equalTo(loginButton!.snp.bottom).offset(8)
            make.left.equalTo(loginButton!.snp.left)
        }
        registerButton?.alpha = 0
        
        registerButton?.addTarget { _ in
            let vc =  InfoModifyController(title: "用户注册", items: ["姓名-输入真实姓名-real_name", "学号-输入学号-stunum", "身份证号-输入身份证号-cid", "用户名-2~12个字母-username", "密码-8~16位英文/符号/数字-password-s", "再次确认-再次输入密码-repass-s"], style: .bottom, headerMsg: "欢迎新用户！请填写以下信息") { result in
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
        authenticateButton?.alpha = 0
        authenticateButton?.addTarget { _ in
            let veteranCheckVC = InfoModifyController(title: "老用户认证", items: ["用户名-输入用户名-username", "姓名-输入姓名-name", "身份证号-输入身份证号-id"], style: .bottom, headerMsg: "老用户（即已拥有BBS账号）请填写以下信息认证") { result in
                // TODO: 逻辑判断
                let resetVC =  InfoModifyController(title: "老用户认证", items: ["新密码-输入新密码-newpass-s", "再次确认-输入新密码-ensure-s"], style: .bottom, headerMsg: "请重置密码，以同步您的个人数据") { result in
                    print(result)
                }
                resetVC.doneText = "确认"
                self.navigationController?.pushViewController(resetVC, animated: true)
            }
            
            // 坑人的需求魔改
            let manualView = UILabel(text: "验证遇到问题？点这里")
            manualView.font = UIFont.systemFont(ofSize: 14)
            manualView.addTapGestureRecognizer { _ in
                let manualCheckVC = InfoModifyController(title: "人工验证", items: ["学号-输入学号-stunum", "姓名-输入姓名-realname", "身份证号-输入身份证号-cid", "用户名-输入以前的用户名-username", "邮箱-输入邮箱-mail", "备注-补充说明其他信息证明您的身份，如曾经发过的帖子名、注册时间、注册邮箱、注册时所填住址等-comment-v"], style: .bottom, headerMsg: "老用户（即已拥有BBS账号）请填写以下信息认证", handler: nil)
                // 因为要索引到VC的某个View, 来加载 HUD
                // 注意循环引用
                manualCheckVC.handler = { [weak manualCheckVC] result in
                    print(result)
                    // TODO: 笑脸的图片
                    HUD.flash(.label("验证信息已经发送至后台管理员，验证结果将会在 1 个工作日内发送至您的邮箱，请注意查收~"), onView: manualCheckVC?.tableView, delay: 4.0)
                }
                manualCheckVC.doneText = "验证"
                self.navigationController?.pushViewController(manualCheckVC, animated: true)
                
            }
            veteranCheckVC.extraView = manualView
            veteranCheckVC.doneText = "验证"
            self.navigationController?.pushViewController(veteranCheckVC, animated: true)
        }
        
        visitorButton = UIButton(title: "游客登录 >", color: UIColor.BBSBlue, fontSize: 16)
        view.addSubview(visitorButton!)
        visitorButton?.snp.makeConstraints {
            make in
            make.bottom.equalTo(view.snp.bottom).offset(-26)
            make.centerX.equalTo(view)
        }
        if let EULAKey = UserDefaults.standard.value(forKey: EULACONFIRMKEY) as? Bool, EULAKey == true {
            visitorButton?.isEnabled = true
        } else {
            visitorButton?.isEnabled = false
        }
        visitorButton?.addTarget {
            _ in
            BBSUser.shared.isVisitor = true
            let tabBarVC = MainTabBarController(para: 1)
            // TODO: 有待商榷
            UserDefaults.standard.set(false, forKey: GUIDEDIDSHOW)
            tabBarVC.modalTransitionStyle = .crossDissolve
            self.present(tabBarVC, animated: false, completion: nil)
        }
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

