//
//  MyPostViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit
import ObjectMapper
import MJRefresh
class MyPostViewController: UIViewController {
    
    var tableView: UITableView?
    var threadList: [ThreadModel] = []
    var page = 0
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "我的发布"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView?.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        self.tableView?.mj_footer.isAutomaticallyHidden = true
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

            if (self.tableView?.mj_header.isRefreshing())! {
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
            if (self.tableView?.mj_footer.isRefreshing())! {
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

extension MyPostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        var thread = threadList[indexPath.row]
        thread.authorID = BBSUser.shared.uid!
        thread.authorName = BBSUser.shared.username ?? thread.authorName
        cell.initUI(thread: thread)
        return cell
    }
    
}

extension MyPostViewController: UITableViewDelegate {
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
