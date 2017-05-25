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

class LatestThreadViewController: UIViewController {
    
    var tableView: UITableView?
    var threadList: [ThreadModel] = []
    var curPage: Int = 0

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        BBSJarvis.getIndex {
//            dict in
//            if let data = dict["data"] as? Dictionary<String, Any>,
//                let latest = data["latest"] as? Array<Dictionary<String, Any>> {
//                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: latest) ?? []
//            }
//            self.tableView?.reloadData()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initUI() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
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
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView?.mj_header.beginRefreshing()
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
        return cell
    }
    
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension LatestThreadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) 
        let detailVC = PostDetailViewController(thread: threadList[indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// refresh
extension LatestThreadViewController {
    func refresh() {
        BBSJarvis.getIndex {
            dict in
            if let data = dict["data"] as? Dictionary<String, Any>,
                let latest = data["latest"] as? Array<Dictionary<String, Any>> {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: latest) ?? []
            }
            if (self.tableView?.mj_header.isRefreshing())! {
                self.tableView?.mj_header.endRefreshing()
            }
            self.tableView?.reloadData()
        }
    }
}
