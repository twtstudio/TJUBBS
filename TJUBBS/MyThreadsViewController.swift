//
//  MyThreadsViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit
import ObjectMapper
import MJRefresh
class MyThreadsViewController: UIViewController {
    
    var tableView: UITableView?
    var threadList: [ThreadModel] = [] {
        didSet {
            if threadList.count > 0 && containerView.superview != nil {
                containerView.removeFromSuperview()
            } else if threadList.count == 0 && containerView.superview == nil {
                if containerView.subviews.count == 0 {
                    let label = UILabel()
                    label.text = "你还没有发表过主题帖呢"
                    label.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
                    label.font = UIFont.boldSystemFont(ofSize: 19)
                    containerView.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.centerY.equalTo(containerView)
                        make.centerX.equalTo(containerView)
                    }
                    label.sizeToFit()
                }
                containerView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
                self.view.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 60, width: self.view.width, height: 40)
                containerView.sizeToFit()
            }
        }
    }
    var page = 0
    var containerView = UIView()
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(108)
            make.left.right.bottom.equalToSuperview()
        }
        tableView?.register(PostCell.self, forCellReuseIdentifier: "threadCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.register(PostCell.self, forCellReuseIdentifier: "postCell")
        
        let rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(self.editingStateOnChange(sender:)))
        self.navigationItem.rightBarButtonItem = rightItem
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
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

        self.tableView?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
//        self.tableView?.mj_footer.isAutomaticallyHidden = true
        self.tableView?.mj_header.beginRefreshing()
    }
    
    
    func refresh() {
        page = 0
        BBSJarvis.getMyThreadList(page: page) {
            dict in
            if let data = dict["data"] as? [[String: Any]] {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: data)
            }
            if self.threadList.count < 49 {
                self.tableView?.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self.tableView?.mj_footer.resetNoMoreData()
            }
            
            if (self.tableView?.mj_header.isRefreshing)! {
                self.tableView?.mj_header.endRefreshing()
            }
            self.tableView?.reloadData()
        }
    }
    
    func load() {
        page += 1
        BBSJarvis.getMyThreadList(page: page) {
            dict in
            if let data = dict["data"] as? [[String: Any]] {
                let fooThreadList = Mapper<ThreadModel>().mapArray(JSONArray: data)
                self.threadList += fooThreadList
                if fooThreadList.count == 0 {
                    self.tableView?.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            if (self.tableView?.mj_footer.isRefreshing)! {
                self.tableView?.mj_footer.endRefreshing()
            }
            self.tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyThreadsViewController {
    func editingStateOnChange(sender: UIBarButtonItem) {
        tableView?.setEditing(!(tableView?.isEditing)!, animated: true)
        if (tableView?.isEditing)! {
            self.navigationItem.rightBarButtonItem?.title = "完成"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "编辑"
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let deleteAlertVC = UIAlertController(title: "确认删除", message: "真的要删除吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        deleteAlertVC.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "删除", style: .destructive) { _ in
            let thread = self.threadList[indexPath.row]
            self.threadList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            BBSJarvis.modifyThread(tid: thread.id, type: "delete", success: {
                self.tableView?.reloadData()
            })
        }
        deleteAlertVC.addAction(confirmAction)
        self.present(deleteAlertVC, animated: true, completion: nil)
    }
    
}

extension MyThreadsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell
        if cell == nil {
            cell = PostCell(style: .default, reuseIdentifier: "postCell")
        }
        var thread = threadList[indexPath.row]
        thread.authorID = BBSUser.shared.uid!
        thread.replyTime = thread.createTime
        thread.authorName = BBSUser.shared.username ?? thread.authorName
        cell?.initUI(thread: thread)
        cell?.timeLablel.text = "发布于 " + (cell?.timeLablel.text ?? "")
        return cell!
    }
    
}

extension MyThreadsViewController: UITableViewDelegate {
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
