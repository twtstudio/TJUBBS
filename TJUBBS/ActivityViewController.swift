//
//  ActivityViewController.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/10/29.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh
import ObjectMapper

class ActivityViewController: UIViewController {

    var tableView = UITableView(frame: .zero, style: .grouped)
    var threadList: [ThreadModel] = [] {
        didSet {
            threadList = threadList.filter { element in
                return BBSUser.shared.blackList.keys.contains(element.authorName) == false
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        UIApplication.shared.statusBarStyle = .default
        self.hidesBottomBarWhenPushed = true
        //        threadList = BBSCache.getTopThread()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "";
        let titleLabel = UILabel(text: "活动", color: .black, fontSize: 18, weight: UIFontWeightMedium)
        self.navigationItem.titleView = titleLabel
        initUI()
    }
    
    func initUI() {
        view.backgroundColor = .lightGray
        //3D Touch
        registerForPreviewing(with: self, sourceView: tableView)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        tableView.register(HotThreadTableViewCell.self, forCellReuseIdentifier: "announceTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        let header = AnimatedRefreshingHeader(target: self, action: #selector(self.refresh))
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
        
    }
    
    func refresh() {
        BBSJarvis.getActivity(success: { dict in
            self.tableView.mj_header.endRefreshing()
            
            if let data = dict["data"] as? [[String: Any]] {
                //                let announce = data["announce"] as? [[String: Any]] {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: data)
            }
            self.tableView.reloadData()
        }, failure: { _ in
            self.tableView.mj_header.endRefreshing()
        })
    }
}

extension ActivityViewController:  UITableViewDataSource, UITableViewDelegate {
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
        return section == 0 ? 10 : 4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "announceTableCell") as! HotThreadTableViewCell
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

extension ActivityViewController: UIViewControllerPreviewingDelegate {
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
