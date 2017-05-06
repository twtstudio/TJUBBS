//
//  UserInfoViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

enum UserInfoViewControllerType {
    case myself
    case others
}

class UserInfoViewController: UIViewController {
    
    let screenFrame = UIScreen.main.bounds
    var headerView: UIView?
    var headerViewBackground: UIImageView?
    var portraitImageView: UIImageView?
    var portraitBadgeLabel: UILabel?
    var usernameLabel: UILabel?
    var signatureLabel: UILabel?
    var pointLabel: UILabel?
    var postNumberLabel: UILabel?
    var ageLabel: UILabel?
    var tableView: UITableView?
    let contentArray = [["我的消息", "我的收藏", "我的发布", "编辑资料"], ["通用设置"]]
    
    //bad way to make navigationBar translucent
    var fooNavigationBarImage: UIImage?
    var fooNavigationBarShadowImage: UIImage?
    
    convenience init(user: AnyObject, type: UserInfoViewControllerType) {
        self.init()
        view.backgroundColor = .white
        self.title = "个人中心"
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
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(-64)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UserInfoTableViewCell.self, forCellReuseIdentifier: "ID")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fooNavigationBarImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
        fooNavigationBarShadowImage = self.navigationController?.navigationBar.shadowImage
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(fooNavigationBarImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = fooNavigationBarShadowImage
        self.navigationController?.navigationBar.isTranslucent = false
    
    }
    
}

extension UserInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserInfoTableViewCell(iconName: contentArray[indexPath.section][indexPath.row], title: contentArray[indexPath.section][indexPath.row], badgeNumber: (indexPath.section == 0 && indexPath.row == 0) ? 5 : 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenFrame.height*(150/1920)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section == 0 else {
            return nil
        }
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height*(820/1920)))
        
        headerViewBackground = UIImageView(image: UIImage(named: "封面"))
        headerViewBackground?.frame = headerView!.bounds
        headerView?.addSubview(headerViewBackground!)
        
        let avatarBackground = UIView()
        headerView?.addSubview(avatarBackground)
        avatarBackground.snp.makeConstraints {
            make in
            make.top.equalTo(headerView!).offset(64)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(screenFrame.height*(240/1920))
        }
        avatarBackground.backgroundColor = .white
        avatarBackground.layer.cornerRadius = screenFrame.height*(240/1920)/2
        avatarBackground.clipsToBounds = true

        portraitImageView = UIImageView(image: UIImage(named: "头像"))
        avatarBackground.addSubview(portraitImageView!)
        portraitImageView?.snp.makeConstraints {
            make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(screenFrame.height*(240/1920)-8)
        }
        portraitImageView?.layer.cornerRadius = (screenFrame.height*(240/1920)-8)/2
        portraitImageView?.clipsToBounds = true
        
        portraitBadgeLabel = UILabel.roundLabel(text: "一般站友", textColor: .white, backgroundColor: .BBSBadgeOrange)
        headerView?.addSubview(portraitBadgeLabel!)
        portraitBadgeLabel?.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(avatarBackground.snp.bottom)
        }
        
        usernameLabel = UILabel(text: "jenny", color: .white, fontSize: 18)
        headerView?.addSubview(usernameLabel!)
        usernameLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(portraitBadgeLabel!.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        signatureLabel = UILabel(text: "你还没有签名哦~", color: .white, fontSize: 16)
        headerView?.addSubview(signatureLabel!)
        signatureLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLabel!.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        postNumberLabel = UILabel(text: "45", color: .white, fontSize: 20)
        headerView?.addSubview(postNumberLabel!)
        postNumberLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(signatureLabel!.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        let postNumberTitleLabel = UILabel(text: "发帖", color: .white, fontSize: 14)
        headerView?.addSubview(postNumberTitleLabel)
        postNumberTitleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(postNumberLabel!.snp.bottom).offset(8)
            make.centerX.equalTo(postNumberLabel!)
        }
        
        pointLabel = UILabel(text: "538", color: .white, fontSize: 20)
        headerView?.addSubview(pointLabel!)
        pointLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(signatureLabel!.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(-screenFrame.width/3)
        }
        
        let pointTitleLabel = UILabel(text: "积分", color: .white, fontSize: 14)
        headerView?.addSubview(pointTitleLabel)
        pointTitleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(pointLabel!.snp.bottom).offset(8)
            make.centerX.equalTo(pointLabel!)
        }
        
        ageLabel = UILabel(text: "98", color: .white, fontSize: 20)
        headerView?.addSubview(ageLabel!)
        ageLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(signatureLabel!.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(screenFrame.width/3)
        }
        
        let ageTitleLabel = UILabel(text: "站龄", color: .white, fontSize: 14)
        headerView?.addSubview(ageTitleLabel)
        ageTitleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(ageLabel!.snp.bottom).offset(8)
            make.centerX.equalTo(ageLabel!)
        }
        
        let dividerLine1 = UIImageView(image: UIImage(color: .white))
        headerView?.addSubview(dividerLine1)
        dividerLine1.snp.makeConstraints {
            make in
            make.top.equalTo(postNumberLabel!)
            make.bottom.equalTo(postNumberTitleLabel)
            make.width.equalTo(1)
            make.centerX.equalToSuperview().offset(-screenFrame.width/6)
        }
        
        let dividerLine2 = UIImageView(image: UIImage(color: .white))
        headerView?.addSubview(dividerLine2)
        dividerLine2.snp.makeConstraints {
            make in
            make.top.equalTo(postNumberLabel!)
            make.bottom.equalTo(postNumberTitleLabel)
            make.width.equalTo(1)
            make.centerX.equalToSuperview().offset(screenFrame.width/6)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return screenFrame.height*(820/1920)
        }
        return 0
    }
}

extension UserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let detailVC = UIViewController()
            detailVC.view.backgroundColor = .white
            detailVC.title = contentArray[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 1, section: 0):
            let detailVC = FavorateViewController(para: 1)
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 3, section: 0):
            let detailVC = SetInfoViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 0, section: 1):
            let detailVC = SettingViewController(para: 1)
            self.navigationController?.pushViewController(detailVC, animated: true)
        default:
            let detailVC = UIViewController()
            detailVC.view.backgroundColor = .white
            detailVC.title = contentArray[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var y = -scrollView.contentOffset.y
        y = y - 64
        guard y > 0 else {
            return
        }
        let ratio = screenFrame.width/(screenFrame.height*(820.0/1920))
        let height = screenFrame.height*(820.0/1920)+y
        let width = height*ratio
        let x = -(width-screenFrame.width)/2.0

        headerViewBackground?.frame = CGRect(x: x, y: -y, width: width, height: height)
    }
}
