//
//  NewUserInfoViewController.swift
//  TJUBBS
//
//  Created by 张毓丹 on 2018/10/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import ObjectMapper


class NewUserInfoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
   
    var userTableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
    var detailArray: [String] = ["我的收藏", "我的发布", "通用设置"]

    //user info
    var userName = ""
    var signature = ""
    var level = "0"
    var avatarView = UIImageView()
    //user data
    var points = "0"
    var age = "0"
    var threadCount = "0"
    //user messageModel
    var messagePage: Int = 0
    var messageList: [MessageModel] = []
    var messageFlag = false
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果不加这两个方法，从个人中心退回来的时候就会NavigationBar和TabBar就会消失
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        if BBSUser.shared.isVisitor == false {
            //需要加游客访问的接口
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "我的", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        self.tabBarController?.tabBar.isTranslucent = false
//        self.userTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        refresh()
        
        let cacheKey = "\(BBSUser.shared.uid ?? 0)" + Date.today
        if let url = URL(string: BBSAPI.avatar(uid: BBSUser.shared.uid ?? 0)) {
           avatarView.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default")) { image, _, _, _ in
                BBSUser.shared.avatar = image
            }
        }
        let user = Mapper<UserWrapper>().map(JSON: ["uid": BBSUser.shared.uid ?? "0", "name": BBSUser.shared.username ?? "求实用户", "signature": BBSUser.shared.signature ?? "还没有个性签名", "points": BBSUser.shared.points ?? 0, "c_post": BBSUser.shared.postCount ?? 0, "c_thread": BBSUser.shared.threadCount ?? 0, "t_create": BBSUser.shared.tCreate ?? "fuck", "level": BBSUser.shared.level ?? 0])!
        loadModel(user: user)
       
        userTableView.dataSource = self
        userTableView.delegate = self
        self.view.addSubview(userTableView)
        
        self.userTableView.estimatedRowHeight = 0
        self.userTableView.estimatedSectionHeaderHeight = 0
        self.userTableView.sectionHeaderHeight = 1
        self.userTableView.sectionFooterHeight = 5
        self.userTableView.estimatedSectionFooterHeight = 0
        userTableView.rowHeight = UITableViewAutomaticDimension
        userTableView.estimatedRowHeight = 300
        userTableView.register(NewUserDataTableViewCell.self, forCellReuseIdentifier: "NewUserDataTableViewCell")
        userTableView.register(NewUserInfoTableViewCell.self, forCellReuseIdentifier: "NewUserInfoTableViewCell")
        userTableView.reloadData()
       
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
        //TODO：后期添加游客访问方法，或者废除？？？
        if BBSUser.shared.isVisitor == false {
            BBSJarvis.getHome(success: { wrapper in
            
            }, failure: { error in
                print(error)
            })
        }
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewUserInfoTableViewCell") as! NewUserInfoTableViewCell
            cell.initUI(avatarImageView: avatarView, userName: self.userName, signature: self.signature, grade: self.level)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewUserDataTableViewCell") as! NewUserDataTableViewCell
            cell.awakeFromNib()
            cell.loadData(points: self.points, threadCount: self.threadCount, age: self.age)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 2{
            let cell = UITableViewCell()
            cell.textLabel?.text = detailArray[indexPath.row]
            cell.imageView?.image = UIImage(named:  detailArray[indexPath.row])
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        let cell = UITableViewCell()
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 2){
            return 3
        }
        return 1
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
            
        case IndexPath(row: 0, section: 0):
            let detailVC = SelfPersonalViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)

        case IndexPath(row: 0, section: 2):
            let detailVC = FavorateViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 1, section: 2):
            let detailVC = MyPostHomeViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 2, section: 2):
            let detailVC = SetInfoViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        default:
            break
        }
    }
  

    func numberOfSections(in tableView: UITableView) -> Int {
        return detailArray.count
    }
    // TODO: 5s及以下的小机型和XR等大机型，需要另行适配
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 110
        }
        else if indexPath.section == 1 {
            return  92
        } else {
            return 54
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
  
    
    func loadModel(user: UserWrapper) {
       self.userName = user.username ?? " "
        if user.signature != nil {
            self.signature = user.signature!
        }else{
        }
//        self.level = "\(user.level ?? 0)"
        self.level = " "
        self.points = "\(user.points ?? 0)"
        self.threadCount = "\((user.postCount ?? 0) + (user.threadCount ?? 0))"
        if let tCreate = user.tCreate {
            self.age = "\(TimeStampTransfer.daysSince(time: tCreate))"
        } else {
            self.age = "0"
        }
    }
    

  
}
    



    

    


