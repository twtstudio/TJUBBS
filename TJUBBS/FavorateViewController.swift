//
//  FavorateViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class FavorateViewController: UIViewController {
    
    var tableView: UITableView?
    var dataList = [
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
        ]
    ]
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
        initUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension FavorateViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        let data = dataList[indexPath.row]
        print(data["username"]!)
        let portraitImage = UIImage(named: data["image"]!)
        cell.initUI(portraitImage: portraitImage, username: data["username"]!, category: data["category"], title: data["title"]!, detail: data["detail"], replyNumber: data["replyNumber"]!, time: data["time"]!)
        
        return cell
    }
}

extension FavorateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
