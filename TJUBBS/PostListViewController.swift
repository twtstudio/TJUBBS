//
//  PostListViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/10.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {
    
    var tableView: UITableView?
    var dataList = [
        [
            "image": "portrait",
            "username": "wangcong",
            "category": "全站热点",
            "title": "厉害了word天大！4项成果获得了2016年国家科技奖",
            "detail": "今天我突然想到天外天，天大bbs，上来看看，好多年没上了，竟然还能用！我 98 级的，一晃这么多年过去了，想当年，这里多热闹啊！",
            "replyNumber": "20",
            "time": "1494061223"
        ],
        [
            "image": "portrait",
            "username": "yqzhufeng",
            "title": "3月26日周日百人狼人单身趴",
            "replyNumber": "20",
            "time": "1494061223"
        ],
        [
            "image": "portrait",
            "username": "yqzhufeng",
            "title": "3月26日周日百人狼人单身趴",
            "replyNumber": "20",
            "time": "1494061223"
        ],
        [
            "image": "portrait",
            "username": "wangcong",
            "category": "全站热点",
            "title": "厉害了word天大！4项成果获得了2016年国家科技奖",
            "detail": "今天我突然想到天外天，天大bbs，上来看看，好多年没上了，竟然还能用！我 98 级的，一晃这么多年过去了，想当年，这里多热闹啊！",
            "replyNumber": "20",
            "time": "1494061223"
        ],
        [
            "image": "portrait",
            "username": "yqzhufeng",
            "title": "3月26日周日百人狼人单身趴",
            "replyNumber": "20",
            "time": "1494061223"
        ]
        ] as Array<Dictionary<String, String>>
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "我的收藏"
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }
}

extension PostListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        let data = dataList[indexPath.row]
        //        print(data["username"]!)
        let portraitImage = UIImage(named: data["image"]!)
        cell.initUI(portraitImage: portraitImage, username: data["username"]!, category: data["category"], favor: false, title: data["title"]!, detail: data["detail"], replyNumber: data["replyNumber"]!, time: data["time"]!)
        
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

extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PostDetailViewController(para: 1)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

