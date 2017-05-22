//
//  MessageViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher

class MessageViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var tableView: UITableView?
//    let dataList = [
//        [
//            "portrait": "头像",
//            "username": "李华",
//            "label": "好友",
//            "detail": "评论了你的帖子：哈哈哈哈厉害了",
//            "time": "1493165223"
//        ],
//        [
//            "portrait": "头像2",
//            "username": "旺仔小馒头",
//            "label": "陌生人",
//            "detail": "回复了你：韩寒会画画后悔画韩红",
//            "time": "1493165223"
//        ],
//        [
//            "portrait": "头像2",
//            "username": "柳永",
//            "label": "陌生人",
//            "detail": "寒蝉凄切，对长亭晚，骤雨初歇。都门帐饮无绪，留恋处，兰舟催发。执手相看泪眼，竟无语凝噎。念去去，千里烟波，暮霭沉沉楚天阔。多情自古伤离别，更那堪，冷落清秋节！今宵酒醒何处？杨柳岸，晓风残月。此去经年，应是良辰好景虚设。便纵有千种风情，更与何人说？",
//            "time": "1493165223"
//        ],
//    ]
    var msgList: [MessageModel] = []
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "我的消息"
        initUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BBSJarvis.getMsgList(page: 0, success: { list in
            print(list)
            self.msgList = list
            self.tableView?.reloadData()
        })
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
//        guard msgList.count != 0 else {
//            let noDataLabel = UILabel(text: "没有消息哦～", color: .gray, fontSize: 20)
//            view.addSubview(noDataLabel)
//            noDataLabel.snp.makeConstraints { $0.center.equalToSuperview() }
//            return
//        }
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView?.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
    }
}

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        let model = msgList[indexPath.row]
        // FIXME: 头像
        cell.initUI(portraitImage: nil, username: model.authorName, time: String(model.t_create), detail: model.content)
        let portraitImage = UIImage(named: "头像")
        let url = URL(string: BBSAPI.avatar(uid: model.authorId))
        let cacheKey = "\(model.authorId)" + Date.today
        cell.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)

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

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = MessageDetailViewController(para: 1)
        detailVC.model = msgList[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
