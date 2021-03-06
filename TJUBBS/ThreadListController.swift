//
//  ThreadListController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import MJRefresh
import Kingfisher
import PKHUD
import PiwikTracker

class ThreadListController: UIViewController {

    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var board: BoardModel?
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
            PiwikTracker.shared.dispatcher.setUserAgent?(DeviceStatus.userAgent)
            PiwikTracker.shared.appName = "bbs.tju.edu.cn/forum/board/\(board?.id ?? bid)/all/page/\(curPage)"
            PiwikTracker.shared.userID = "[\(BBSUser.shared.uid ?? 0)] \"\(BBSUser.shared.username ?? "unknown")\""
            PiwikTracker.shared.sendView("")
        }
    }
    var bid: Int = 0
    var boardName: String = ""

    convenience init(board: BoardModel?) {
        self.init()
        self.board = board
        view.backgroundColor = .lightGray
        self.hidesBottomBarWhenPushed = true
    }

    convenience init(bid: Int) {
        self.init()
        view.backgroundColor = .lightGray
        self.hidesBottomBarWhenPushed = true
        self.bid = bid
    }
    
    convenience init(bid: Int, boardName: String) {
        self.init()
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.bid = bid
        self.boardName = boardName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        // 3D Touch
        registerForPreviewing(with: self, sourceView: self.tableView)

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(0)
            make.left.right.bottom.equalToSuperview()
        }
        registerForPreviewing(with: self, sourceView: tableView)
        tableView.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        var titleLabel = UILabel()
        
        let name = board?.name ?? boardName
        titleLabel = UILabel(text: name, color: .black, fontSize: 18, weight: UIFontWeightMedium)
        
        self.navigationItem.titleView = titleLabel
        
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem

        //TODO: put this in view did load
//        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))

        let header = AnimatedRefreshingHeader(target: self, action: #selector(self.refresh))
        tableView.mj_header = header

        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        //self.tableView.mj_footer.isAutomaticallyHidden = true
        self.tableView.mj_header.beginRefreshing()

        // 右侧按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let rightButtonTitleLabel = UILabel(text: board?.name ?? "帖子", color: .black, fontSize: 16, weight: UIFontWeightBold)
        self.navigationItem.titleView = rightButtonTitleLabel
    }

    func addButtonTapped() {
        guard BBSUser.shared.token != nil else {
            let alert = UIAlertController(title: "请先登录", message: "BBS需要登录才能发布消息", preferredStyle: .alert)
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

        let addVC = AddThreadViewController()
        addVC.selectedBoard = self.board
        addVC.tableView.allowsSelection = false
        self.navigationController?.pushViewController(addVC, animated: true)
    }
}

extension ThreadListController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        let thread = threadList[indexPath.row]
        cell.initUI(thread: thread)
        return cell
    }

}

extension ThreadListController: UITableViewDelegate {
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

extension ThreadListController {
    func refresh() {
        self.curPage = 0
        BBSJarvis.getThreadList(boardID: board?.id ?? bid, page: 0, failure: { _ in
                if self.tableView.mj_header.isRefreshing {
                    self.tableView.mj_header.endRefreshing()
                }
        }) {
            dict in
            if let data = dict["data"] as? [String: Any],
                let board = data["board"] as? [String: Any],
                let threads = data["thread"] as? [[String: Any]] {
                if (self.tableView.mj_header.isRefreshing) {
                    self.tableView.mj_header.endRefreshing()
                }
                self.curPage = 0
                let boardModel = Mapper<BoardModel>().map(JSON: board)
                self.board = boardModel
                self.title = boardModel?.name
                (self.navigationItem.titleView as? UILabel)?.text = boardModel?.name
                self.navigationItem.titleView?.sizeToFit()
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: threads)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func load() {
        self.curPage += 1
        BBSJarvis.getThreadList(boardID: board!.id, page: curPage, failure: { _ in
            HUD.flash(.labeledError(title: "网络错误...", subtitle: nil), onView: self.view, delay: 1.2, completion: nil)
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
            }
        }, success: { dict in
            self.tableView.mj_footer.endRefreshing()

            if let data = dict["data"] as? [String: Any],
                let threads = data["thread"] as? [[String: Any]] {
                let newList = Mapper<ThreadModel>().mapArray(JSONArray: threads)
                if newList.isEmpty {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.threadList += newList
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

extension ThreadListController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) {
            previewingContext.sourceRect = cell.frame
            let detailVC = ThreadDetailViewController(thread: threadList[indexPath.row])
            return detailVC
            //        previewingContext.sourceRect =
        }
        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
