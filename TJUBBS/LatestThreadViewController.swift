//
//  PostListViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import Kingfisher
import MJRefresh
import PiwikTracker

class LatestThreadViewController: UIViewController {
    
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
        }
    }
    var curPage: Int = 0 {
        didSet {
            // FIXME: 最新动态第多少页
//            PiwikTracker.shared.dispatcher.setUserAgent?(DeviceStatus.userAgent)
//            PiwikTracker.shared.appName = "bbs.tju.edu.cn/forum/board/\(board?.id ?? bid)/all/page/\(curPage)"
//            PiwikTracker.shared.userID = "[\(BBSUser.shared.uid ?? 0)] \"\(BBSUser.shared.username ?? "unknown")\""
//            PiwikTracker.shared.sendView("")
        }
    }

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
                
        registerForPreviewing(with: self, sourceView: tableView!)
        tableView?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(108)
            make.left.right.bottom.equalToSuperview()
        }
        tableView?.register(PostCell.self, forCellReuseIdentifier: "postCell")
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
//        tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        tableView?.mj_header.beginRefreshing()
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(load))
        footer?.setTitle("还没看过瘾？去分区看看吧~", for: .noMoreData)
        self.tableView?.mj_footer = footer
        //self.tableView?.mj_footer.isAutomaticallyHidden = true

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PiwikTracker.shared.dispatcher.setUserAgent?(DeviceStatus.userAgent)
        PiwikTracker.shared.appName = "bbs.tju.edu.cn"
        PiwikTracker.shared.userID = "[\(BBSUser.shared.uid ?? 0)] \"\(BBSUser.shared.username ?? "unknown")\""
        PiwikTracker.shared.sendView("")
    }
}

extension LatestThreadViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        let data = threadList[indexPath.row]
        cell.initUI(thread: data)
        cell.boardButton.isHidden = false
        cell.boardButton.addTarget { _ in
            let boardVC = ThreadListController(bid: data.boardID)
            self.navigationController?.pushViewController(boardVC, animated: true)
        }
        if data.anonymous == 0 { // exclude anonymous user
            cell.usernameLabel.addTapGestureRecognizer { _ in
                let userVC = HHUserDetailViewController(uid: data.authorID)
                self.navigationController?.pushViewController(userVC, animated: true)
            }
            cell.portraitImageView.addTapGestureRecognizer { _ in
                let userVC = HHUserDetailViewController(uid: data.authorID)
                self.navigationController?.pushViewController(userVC, animated: true)
            }
        }
        return cell
    }
    
}

extension LatestThreadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) 
        let detailVC = ThreadDetailViewController(thread: threadList[indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

}

// refresh
extension LatestThreadViewController {
    func refresh() {
        // refresh message count
        BBSJarvis.getMessageCount(success: { dict in
            if let count = dict["data"] as? Int, count != 0 {
                self.tabBarController?.tabBar.items![2].badgeValue = "\(count)"
            }
        })

        curPage = 0
        BBSJarvis.getIndex(page: curPage, failure: { _ in
            if (self.tableView?.mj_header.isRefreshing)! {
                self.tableView?.mj_header.endRefreshing()
            }
        }, success: { dict in
            if let data = dict["data"] as? Array<Dictionary<String, Any>> {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: data)
            }
            self.tableView?.mj_footer.resetNoMoreData()
            if (self.tableView?.mj_header.isRefreshing)! {
                self.tableView?.mj_header.endRefreshing()
            }
            self.tableView?.reloadData()
        })
    }
    
    func load() {
        curPage += 1
        
        BBSJarvis.getIndex(page: curPage, failure: { _ in
            self.curPage -= 1
            if (self.tableView?.mj_footer.isRefreshing)! {
                self.tableView?.mj_footer.endRefreshing()
            }
        }, success: { dict in
            if let data = dict["data"] as? Array<Dictionary<String, Any>> {
                let newList = Mapper<ThreadModel>().mapArray(JSONArray: data)
                if newList.count > 0 {
                    self.threadList += newList
                } else {
                    self.tableView?.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            if (self.tableView?.mj_footer.isRefreshing)! {
                self.tableView?.mj_footer.endRefreshing()
            }
            self.tableView?.reloadData()
        })
    }
}

extension LatestThreadViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView?.indexPathForRow(at: location), let cell = tableView?.cellForRow(at: indexPath) {
            previewingContext.sourceRect = cell.frame
            let detailVC = ThreadDetailViewController(thread: threadList[indexPath.row])
            return detailVC
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
