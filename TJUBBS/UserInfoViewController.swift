//
//  UserInfoViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher

enum UserInfoViewControllerType {
    case myself
    case others
}

class UserInfoViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    // Used to set header
    let magicNumber: CGFloat = UIScreen.main.bounds.size.width > 320 ? 820.0 : 900.0
    let ratio = UIScreen.main.bounds.size.width/375.0
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
        
        // 导航栏返回按钮文字为空
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
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
        portraitImageView?.image = BBSUser.shared.avatar ?? UIImage(named: "头像")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        tableView?.reloadData()
        
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
        return screenSize.height*(150/1920)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard section == 0 else {
            return nil
        }
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height*(magicNumber/1920)))
        
        headerViewBackground = UIImageView(image: UIImage(named: "封面"))
        headerViewBackground?.frame = headerView!.bounds
        headerView?.addSubview(headerViewBackground!)
        
        let avatarBackground = UIView()
        headerView?.addSubview(avatarBackground)
        avatarBackground.backgroundColor = .white
        avatarBackground.clipsToBounds = true

        // TODO: 默认头像
        portraitImageView = UIImageView()
        let url = URL(string: BBSAPI.avatar)
        let cacheKey = "\(BBSUser.shared.uid ?? 0000)" + Date.today
        if let url = url {
            portraitImageView!.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey)) { image, error, cacheType, imageURL in
                BBSUser.shared.avatar = image
            }
        }
        portraitImageView?.clipsToBounds = true
        avatarBackground.addSubview(portraitImageView!)

        
        if screenSize.width > 320 {
            avatarBackground.snp.makeConstraints {
                make in
                make.top.equalTo(headerView!).offset(64)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(screenSize.height*(240/1920)*ratio)
            }
            avatarBackground.layer.cornerRadius = screenSize.height*(240/1920)*ratio/2
            
            portraitImageView?.snp.makeConstraints {
                make in
                make.centerX.centerY.equalToSuperview()
                make.width.height.equalTo(screenSize.height*(240.0/1920.0)*ratio-8)
            }
            portraitImageView?.layer.cornerRadius = (screenSize.height*(240.0/1920.0)*ratio-8)/2
        } else { // small iPhone like 5S
            avatarBackground.snp.makeConstraints {
                make in
                make.top.equalTo(headerView!).offset(64)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(78)
            }
            avatarBackground.layer.cornerRadius = 78/2
            
            portraitImageView?.snp.makeConstraints {
                make in
                make.centerX.centerY.equalToSuperview()
                make.width.height.equalTo(70)
            }
            portraitImageView?.layer.cornerRadius = 70/2
        }
        portraitImageView?.addTapGestureRecognizer { _ in
            let setInfoVC = SetInfoViewController()
            self.navigationController?.pushViewController(setInfoVC, animated: true)
        }
        
        // FIXME: 称号？？？
        portraitBadgeLabel = UILabel.roundLabel(text: "一般站友", textColor: .white, backgroundColor: .BBSBadgeOrange)
        headerView?.addSubview(portraitBadgeLabel!)
        portraitBadgeLabel?.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(avatarBackground.snp.bottom)
        }
        
        // FIXME: placeholder
        usernameLabel = UILabel(text: BBSUser.shared.nickname ?? "null", color: .white, fontSize: 18)
        headerView?.addSubview(usernameLabel!)
        usernameLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(portraitBadgeLabel!.snp.bottom).offset(8*ratio)
            make.centerX.equalToSuperview()
        }
        
        signatureLabel = UILabel(text: BBSUser.shared.signature ?? "你还没有签名哦~", color: .white, fontSize: 16)
        headerView?.addSubview(signatureLabel!)
        signatureLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(usernameLabel!.snp.bottom).offset(8*ratio)
            make.centerX.equalToSuperview()
        }
        
        postNumberLabel = UILabel(text: "\(BBSUser.shared.postCount ?? 0)", color: .white, fontSize: 20)
        headerView?.addSubview(postNumberLabel!)
        postNumberLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(signatureLabel!.snp.bottom).offset(12*ratio)
            make.centerX.equalToSuperview()
        }
        
        let postNumberTitleLabel = UILabel(text: "发帖", color: .white, fontSize: 14)
        headerView?.addSubview(postNumberTitleLabel)
        postNumberTitleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(postNumberLabel!.snp.bottom).offset(4*ratio)
            make.centerX.equalTo(postNumberLabel!)
        }
        
        pointLabel = UILabel(text: "\(BBSUser.shared.points ?? 0)", color: .white, fontSize: 20)
        headerView?.addSubview(pointLabel!)
        pointLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(signatureLabel!.snp.bottom).offset(12*ratio)
            make.centerX.equalToSuperview().offset(-screenSize.width/3)
        }
        
        let pointTitleLabel = UILabel(text: "积分", color: .white, fontSize: 14)
        headerView?.addSubview(pointTitleLabel)
        pointTitleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(pointLabel!.snp.bottom).offset(4*ratio)
            make.centerX.equalTo(pointLabel!)
        }
        
        ageLabel = UILabel(text: "\(BBSUser.shared.cOnline ?? 0)", color: .white, fontSize: 20)
        headerView?.addSubview(ageLabel!)
        ageLabel?.snp.makeConstraints {
            make in
            make.top.equalTo(signatureLabel!.snp.bottom).offset(12*ratio)
            make.centerX.equalToSuperview().offset(screenSize.width/3)
        }
        let dayLabel = UILabel(text: "天", color: .white, fontSize: 8)
        headerView?.addSubview(dayLabel)
        dayLabel.snp.makeConstraints {
            make in
            make.bottom.equalTo(ageLabel!.snp.bottom)
            make.left.equalTo(ageLabel!.snp.right)
        }
        
        let ageTitleLabel = UILabel(text: "站龄", color: .white, fontSize: 14)
        headerView?.addSubview(ageTitleLabel)
        ageTitleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(ageLabel!.snp.bottom).offset(4*ratio)
            make.centerX.equalTo(ageLabel!)
        }
        
        let dividerLine1 = UIImageView(image: UIImage(color: .white))
        headerView?.addSubview(dividerLine1)
        dividerLine1.snp.makeConstraints {
            make in
            make.top.equalTo(postNumberLabel!)
            make.bottom.equalTo(postNumberTitleLabel)
            make.width.equalTo(1)
            make.centerX.equalToSuperview().offset(-screenSize.width/6)
        }
        
        let dividerLine2 = UIImageView(image: UIImage(color: .white))
        headerView?.addSubview(dividerLine2)
        dividerLine2.snp.makeConstraints {
            make in
            make.top.equalTo(postNumberLabel!)
            make.bottom.equalTo(postNumberTitleLabel)
            make.width.equalTo(1)
            make.centerX.equalToSuperview().offset(screenSize.width/6)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return screenSize.height*(magicNumber/1920)
//            return screenSize.height*(820/1920)
        }
        return 0
    }
}

extension UserInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let detailVC = MessageViewController(para: 1)
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 1, section: 0):
            let detailVC = FavorateViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 2, section: 0):
            let detailVC = MyPostViewController(para: 1)
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 3, section: 0):
            let detailVC = SetInfoViewController()
            self.navigationController?.pushViewController(detailVC, animated: true)
        case IndexPath(row: 0, section: 1):
            let detailVC = SettingViewController()
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
        let ratio = screenSize.width/(screenSize.height*(magicNumber/1920))
        let height = screenSize.height*(magicNumber/1920)+y
        let width = height*ratio
        let x = -(width-screenSize.width)/2.0

        headerViewBackground?.frame = CGRect(x: x, y: -y, width: width, height: height)
    }
}
