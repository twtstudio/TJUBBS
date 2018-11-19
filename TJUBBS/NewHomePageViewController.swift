//
//  NewHomePageViewController.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/6/6.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

import ObjectMapper
import Kingfisher
import MJRefresh
import PiwikTracker

class NewHomePageViewController: UIViewController {
    var tableView = UITableView(frame: .zero, style: .grouped)

    var threadList: [ThreadModel] = [] {
        didSet {
            let isNoJobMode = UserDefaults.standard.bool(forKey: "noJobMode")
            threadList = threadList.filter { element in
                let isInBlackList = BBSUser.shared.blackList.keys.contains(element.authorName)
                let isJobRelated = [188, 189].contains(element.boardID) && isNoJobMode
                return !isInBlackList && !isJobRelated
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
    var headerView = HomePageHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.15))

//    var pic: [UIImageView] = [UIImageView]()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .lightGray
//        self.hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        headerView.eliteButton.addTarget { _ in
            let hotVC = HottestThreadViewController()
            self.navigationController?.pushViewController(hotVC, animated: true)
        }
        
        headerView.announceButton.addTarget { _ in
            let announceVC = AnnounceViewController()
            self.navigationController?.pushViewController(announceVC, animated: true)
        }
        
        headerView.activityButton.addTarget { _ in
            let activityVC = ActivityViewController()
            self.navigationController?.pushViewController(activityVC, animated: true)
        }
        
        headerView.rankButton.addTarget { _ in
            let rankListVC = RankListViewController()
            self.navigationController?.pushViewController(rankListVC, animated: true)
        }
        
        
        registerForPreviewing(with: self, sourceView: tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(HomePageThreadTableViewCell.self, forCellReuseIdentifier: "NewThreadCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        self.tableView.separatorStyle = .none

        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGray], for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchToggled(sender:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray

//        var timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(NewHomePageViewController.pageNumberChanged(sender:)), userInfo: nil, repeats: true)
        let item = UIBarButtonItem(title: "最新动态", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = item

        let header = AnimatedRefreshingHeader(target: self, action: #selector(self.refresh))
        tableView.mj_header = header

        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(load))
        footer?.setTitle("还没看过瘾？去分区看看吧~", for: .noMoreData)
        self.tableView.mj_footer = footer

        self.loadCache()
        self.tableView.mj_header.beginRefreshing()
//        self.tabBarItem.hidesBottomBarWhenPushed = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            // Fallback on earlier versions
        }
        PiwikTracker.shared.dispatcher.setUserAgent?(DeviceStatus.userAgent)
        PiwikTracker.shared.appName = "bbs.tju.edu.cn"
        PiwikTracker.shared.userID = "[\(BBSUser.shared.uid ?? 0)] \"\(BBSUser.shared.username ?? "unknown")\""
        PiwikTracker.shared.sendView("")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        self.navigationController?.navigationBar.showBottomHairline()
    }

    @objc func searchToggled(sender: UIButton) {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension NewHomePageViewController {
    func loadCache() {
        BBSCache.retreive(.threadList, from: .group, as: String.self, success: { str in
            if let threadList = Mapper<ThreadModel>().mapArray(JSONString: str) {
                self.threadList = threadList
                self.tableView.reloadData()
            }
        })
    }

    func refresh() {
        BBSJarvis.getMessageCount(success: { dict in
            if let count = dict["data"] as? Int, count != 0 {
                self.tabBarController?.tabBar.items![2].badgeValue = "\(count)"
            }
        })

        curPage = 0
        BBSJarvis.getIndex(page: curPage, failure: { _ in
            self.tableView.mj_header.endRefreshing()
        }, success: { dict in
            if let data = dict["data"] as? [[String: Any]] {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: data)
                BBSCache.store(object: self.threadList.toJSONString(), in: .group, as: .threadList)
                self.tableView.reloadData()
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.tableView.mj_header.endRefreshing()
        })
    }
    
    func load() {
        curPage += 1
        BBSJarvis.getIndex(page: curPage, failure: { _ in
            self.tableView.mj_footer.endRefreshing()
            self.curPage -= 1
        }, success: { dict in
            self.tableView.mj_footer.endRefreshing()

            if let data = dict["data"] as? [[String: Any]] {
                let newList = Mapper<ThreadModel>().mapArray(JSONArray: data)
                if newList.count > 0 {
                    self.threadList += newList
                    self.tableView.reloadData()
                    BBSCache.store(object: self.threadList.toJSONString(), in: .group, as: .threadList)
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
        })
    }
}
extension NewHomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ThreadDetailViewController(thread: threadList[indexPath.section])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return UIView(frame: .zero)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerView.height
        }
        return 4
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }

}

extension NewHomePageViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return threadList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewThreadCell") as! HomePageThreadTableViewCell
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

extension NewHomePageViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) {
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
