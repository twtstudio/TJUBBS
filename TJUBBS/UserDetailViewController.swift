//
//  UserDetailViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/4.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import Kingfisher

class UserDetailViewController: UIViewController {
    let headerView = UIView()
    let avatarViewBackground = UIImageView()
    let avatarView = UIImageView()
    let frostView = UIVisualEffectView()
    let usernameLabel = UILabel(text: "", color: .white, fontSize: 18)
    let signatureLabel = UILabel(text: "", color: .white, fontSize: 16)
    let scoreLabel = UILabel(text: "", color: .white, fontSize: 20)
    let threadCountLabel = UILabel(text: "", color: .white, fontSize: 20)
    let ageLabel = UILabel(text: "", color: .white, fontSize: 20)
    let tableView = UITableView(frame: .zero, style: .grouped)
    var user: UserWrapper?
    let containerView = UIView() // empty

    convenience init(user: UserWrapper) {
        self.init()
        self.user = user
        loadModel()
    }

    convenience init(uid: Int) {
        self.init()
        BBSJarvis.getHome(uid: uid, success: { user in
            self.user = user
            self.loadModel()
            self.tableView.reloadData()
        }, failure: { _ in
            // FIXME: error page
        
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set navigationBar clear        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func loadModel() {
        if let user = user {
            usernameLabel.text = user.username
            signatureLabel.text = user.signature
            scoreLabel.text = "\(user.points ?? 0)"
            threadCountLabel.text = "\((user.postCount ?? 0) + (user.threadCount ?? 0))"
            ageLabel.text = "\(TimeStampTransfer.daysSince(time: user.tCreate ?? Int(Date().timeIntervalSince1970)))"
            let cacheKey = "\(user.uid ?? 0)" + Date.today
            if let url = URL(string: BBSAPI.avatar(uid: user.uid ?? 0)) {
                avatarView.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
                avatarViewBackground.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
            }
            if user.recentThreads.count == 0 {
                let label = UILabel(text: "Ta最近还没有发表过帖子", fontSize: 17)
                containerView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerY.equalTo(containerView)
                    make.centerX.equalTo(containerView)
                }
                containerView.backgroundColor = .white
                label.sizeToFit()
                self.view.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 296, width: self.view.width, height: 40)
                containerView.sizeToFit()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // layout here
//        self.view.addSubview(headerView)
//        headerView.snp.makeConstraints { make in
//            make.top.left.right.equalToSuperview()
//        }
        
        self.headerView.addSubview(avatarViewBackground)
        avatarViewBackground.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        headerView.addSubview(frostView)
        frostView.effect = UIBlurEffect(style: .dark)
        frostView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(avatarViewBackground)
        }
        
        let avatarHeight: CGFloat = 80
        avatarView.layer.cornerRadius = avatarHeight/2
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.masksToBounds = true
        
        headerView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(64)
            make.height.width.equalTo(avatarHeight)
        }
        
        avatarView.addTapGestureRecognizer { [weak avatarView]_ in
            let detailVC = ImageDetailViewController(image: avatarView?.image ?? UIImage(named: "default")!)
            detailVC.showSaveBtn = true
            self.modalPresentationStyle = .overFullScreen
            self.present(detailVC, animated: true, completion: nil)
        }

        
        headerView.addSubview(usernameLabel)
        usernameLabel.numberOfLines = 1
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(10)
            make.height.equalTo(21.5)
        }
        
        headerView.addSubview(signatureLabel)
        signatureLabel.numberOfLines = 1
        signatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom).offset(10)
            make.height.equalTo(19.5)
        }
        
        let baseWidth = self.view.width/6
        
        headerView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(1*baseWidth)
            make.top.equalTo(signatureLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        let scoreHintLabel = UILabel(text: "积分", color: .white, fontSize: 14)
        headerView.addSubview(scoreHintLabel)
        scoreHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(1*baseWidth)
            make.top.equalTo(scoreLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        headerView.addSubview(threadCountLabel)
        threadCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(3*baseWidth)
            make.top.equalTo(signatureLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        let threadHintLabel = UILabel(text: "发帖", color: .white, fontSize: 14)
        headerView.addSubview(threadHintLabel)
        threadHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(3*baseWidth)
            make.top.equalTo(threadCountLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().offset(-10)
        }

        headerView.addSubview(ageLabel)
        ageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(5*baseWidth)
            make.top.equalTo(signatureLabel.snp.bottom).offset(10)
            make.height.equalTo(24)
        }
        let ageHintLabel = UILabel(text: "站龄", color: .white, fontSize: 14)
        headerView.addSubview(ageHintLabel)
        ageHintLabel.snp.makeConstraints { make in
            make.centerX.equalTo(5*baseWidth)
            make.top.equalTo(ageLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().offset(-10)
        }
        let dayLabel = UILabel(text: "天", color: .white, fontSize: 8)
        headerView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.bottom.equalTo(ageLabel.snp.bottom)
            make.left.equalTo(ageLabel.snp.right)
        }

        let divider1 = UIView()
        divider1.backgroundColor = .white
        let divider2 = UIView()
        divider2.backgroundColor = .white
        
        headerView.addSubview(divider1)
        divider1.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.top)
            make.bottom.equalTo(scoreHintLabel.snp.bottom)
            make.width.equalTo(1)
            make.left.equalTo(2*baseWidth)
        }
        headerView.addSubview(divider2)
        divider2.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.top)
            make.bottom.equalTo(scoreHintLabel.snp.bottom)
            make.width.equalTo(1)
            make.left.equalTo(4*baseWidth)
        }
        
        headerView.sizeToFit()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        self.navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
//        self.navigationController?.navigationBar.setBackgroundImage(fooNavigationBarImage, for: .default)
//        self.navigationController?.navigationBar.shadowImage = fooNavigationBarShadowImage
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.automaticallyAdjustsScrollViewInsets = true
//        self.navigationController?.navigationBar.setBackgroundImage(fooNavigationBarImage, for: .default)
//        self.navigationController?.navigationBar.shadowImage = fooNavigationBarShadowImage
////        self.navigationController?.navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:.default)
////        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
////        self.navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 276
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ThreadDetailViewController(thread: user!.recentThreads[indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.recentThreads.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thread = user!.recentThreads[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UserThreadCell")
        let timeLabel = UILabel(text: TimeStampTransfer.timeLabelSince(time: thread.createTime) + " 发布帖子", color: .lightGray, fontSize: 14)
        let titleLabel = UILabel(text: thread.title, fontSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        cell.contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
        }
        cell.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
        return cell
    }
}

extension UserDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        guard y > 0 else {
            containerView.y = 276 + y + 20
            return
        }
        let ratio = self.view.width/276
        let height = 276 + y
        let width = height*ratio
//        let x = -(width-self.view.width)/2.0
        avatarViewBackground.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalTo(width)
            make.centerX.equalTo(avatarView)
            make.height.equalTo(height+1)
        }
        frostView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(avatarView)
            make.width.equalTo(width)
            make.height.equalTo(height+1)
        }
        containerView.y = height + 20
    }
}
