//
//  HottestThreadViewController.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/10/14.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import Kingfisher
import MJRefresh

class HottestThreadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView?
    var threadList: [ThreadModel] = [] {
        didSet {
            threadList = threadList.filter { element in
                for username in BBSUser.shared.blackList.keys {
                    if username == element.authorName {
                        return false
                    }
                }
                return true
            }
            BBSCache.saveTopThread(threads: threadList)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .default
        self.hidesBottomBarWhenPushed = true
        threadList = BBSCache.getTopThread()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "";
        let titleLabel = UILabel(text: "十大热帖", color: .black, fontSize: 18, weight: UIFontWeightMedium)
        self.navigationItem.titleView = titleLabel
        initUI()
    }

    func initUI() {
        view.backgroundColor = .lightGray
        tableView = UITableView(frame: .zero, style: .grouped)
        //3D Touch
        registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: tableView!)
        
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints {
            make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        tableView?.register(HotThreadTableViewCell.self, forCellReuseIdentifier: "hotThreadCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        
        let header = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        var refreshingImages = [UIImage]()
        for i in 1...6 {
            let image = UIImage(named: "鹿鹿\(i)")?.kf.resize(to: CGSize(width: 60, height: 60))
            refreshingImages.append(image!)
        }
        header?.setImages(refreshingImages, duration: 0.2, for: .pulling)
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setImages(refreshingImages, for: .pulling)
        tableView?.mj_header = header
        tableView?.mj_header.beginRefreshing()
        
    }
    
    func refresh() {
        // refresh message count
        BBSJarvis.getMessageCount(success: { dict in
            if let count = dict["data"] as? Int, count != 0 {
                self.tabBarController?.tabBar.items![2].badgeValue = "\(count)"
            }
        })
        
        BBSJarvis.getHot(success: { dict in
            if let data = dict["data"] as? [String: Any],
                let hot = data["hot"] as? [[String: Any]] {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: hot)
            }
            if (self.tableView?.mj_header.isRefreshing)! {
                self.tableView?.mj_header.endRefreshing()
            }
            self.tableView?.reloadData()
        }, failure: { _ in
            if (self.tableView?.mj_header.isRefreshing)! {
                self.tableView?.mj_header.endRefreshing()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HottestThreadViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return threadList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ThreadDetailViewController(thread: threadList[indexPath.section])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 4
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotThreadCell") as! HotThreadTableViewCell
        let data = threadList[indexPath.section]
        cell.loadModel(thread: data)
        cell.boardButton.isHidden = false
        cell.boardButton.addTarget { _ in
            let boardVC = ThreadListController(bid: data.boardID, boardName: data.boardName)
            self.navigationController?.pushViewController(boardVC, animated: true)
        }
        if data.anonymous == 0 { // exclude anonymous user
            cell.nameLabel.addTapGestureRecognizer { _ in
                let userVC = HHUserDetailViewController(uid: data.authorID)
                self.navigationController?.pushViewController(userVC, animated: true)
            }
            cell.avatarImageView.addTapGestureRecognizer { _ in
                let userVC = HHUserDetailViewController(uid: data.authorID)
                self.navigationController?.pushViewController(userVC, animated: true)
            }
        }
        return cell
    }
}

extension HottestThreadViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView?.indexPathForRow(at: location), let cell = tableView?.cellForRow(at: indexPath) {
            previewingContext.sourceRect = cell.frame
            let detailVC = ThreadDetailViewController(thread: threadList[indexPath.section])
            return detailVC
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
