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
    let tableView = UITableView(frame: .zero, style: .grouped)
    let headerView = UserDetailView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 276))
    var user: UserWrapper?
    let containerView = UIView() // empty

    convenience init(user: UserWrapper) {
        self.init()
        self.user = user
        headerView.loadModel(user: user)
        self.loadDetail()
    }

    convenience init(uid: Int) {
        self.init()
        BBSJarvis.getHome(uid: uid, success: { user in
            self.user = user
            self.loadDetail()
            self.headerView.loadModel(user: user)
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
    
    func loadDetail() {
        if let user = user {
            let cacheKey = "\(user.uid ?? 0)" + Date.today
            if let url = URL(string: BBSAPI.avatar(uid: user.uid ?? 0)) {
                headerView.avatarView.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
                headerView.avatarViewBackground.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
            }
            if user.recentThreads.count == 0 {
                //                let label = UILabel(text: "Ta最近还没有发表过帖子", color: UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00), fontSize: 17)
                let label = UILabel()
                label.text = "Ta最近还没有发表过帖子"
                label.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
                label.font = UIFont.boldSystemFont(ofSize: 19)
                containerView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerY.equalTo(containerView)
                    make.centerX.equalTo(containerView)
                }
                //                containerView.backgroundColor = .white
                containerView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
                label.sizeToFit()
                self.view.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 306, width: self.view.width, height: 40)
                containerView.sizeToFit()
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3D Touch
        registerForPreviewing(with: self, sourceView: self.tableView)
        
        // layout here
        tableView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        
        headerView.avatarView.addTapGestureRecognizer { [weak headerView]_ in
            let detailVC = ImageDetailViewController(image: headerView?.avatarView.image ?? UIImage(named: "default")!)
            detailVC.showSaveBtn = true
            self.modalPresentationStyle = .overFullScreen
            self.present(detailVC, animated: true, completion: nil)
        }
        
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
        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        self.navigationController?.navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
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
            containerView.y = 306 + y
            return
        }
        let ratio = self.view.width/276
        let height = 276 + y
        let width = height*ratio
        headerView.avatarViewBackground.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalTo(width)
            make.centerX.equalTo(headerView.avatarView)
            make.height.equalTo(height+1)
        }
        headerView.frostView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(headerView.avatarView)
            make.width.equalTo(width)
            make.height.equalTo(height+1)
        }
        containerView.y = height + 30
    }
}

extension UserDetailViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) {
            previewingContext.sourceRect = cell.frame
            let detailVC = ThreadDetailViewController(thread: user!.recentThreads[indexPath.row])
            return detailVC
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

