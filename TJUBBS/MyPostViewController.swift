//
//  MyPostViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit
import ObjectMapper
class MyPostViewController: UIViewController {
    
    var tableView: UITableView?
//    var dataList = [
//        [
//            "image": "头像2",
//            "username": "苏轼",
//            "title": "念奴娇·赤壁怀古",
//            "replyNumber": "20",
//            "time": "1494061223"
//        ],
//        [
//            "image": "头像2",
//            "username": "苏轼",
//            "title": "水调歌头·明月几时有",
//            "replyNumber": "20",
//            "time": "1494061223"
//        ],
//        [
//            "image": "头像2",
//            "username": "苏轼",
//            "title": "江城子·乙卯正月二十日夜记梦",
//            "replyNumber": "20",
//            "time": "1494061223"
//        ]
//    ] as Array<Dictionary<String, String>>
    var threadList: [ThreadModel] = []
    var page = 0
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "我的发布"
        initUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refresh()
    }
    
    func refresh() {
        BBSJarvis.getMyThreadList(page: page) {
            dict in
            if let data = dict["data"] as? [[String: Any]] {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: data)!
            }
            self.tableView?.reloadData()
        }
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
        tableView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView?.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
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
        let thread = threadList[indexPath.row]
        cell.initUI(thread: thread)
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

extension MyPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PostDetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
