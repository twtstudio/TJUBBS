//
//  MessageDetailViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    
    let screenFrame = UIScreen.main.bounds
    var tableView: UITableView?
    let data = [
        "portrait": "头像2",
        "sign": "飘飘何所似，天地一沙鸥",
        "username": "柳永",
        "label": "陌生人",
        "detail": "评论了你的帖子:\n寒蝉凄切，对长亭晚，骤雨初歇。都门帐饮无绪，留恋处，兰舟催发。执手相看泪眼，竟无语凝噎。念去去，千里烟波，暮霭沉沉楚天阔。多情自古伤离别，更那堪，冷落清秋节！今宵酒醒何处？杨柳岸，晓风残月。此去经年，应是良辰好景虚设。便纵有千种风情，更与何人说？",
        "postTitle": "这个时候我就念两句诗",
        "postAuthor": "不可描述",
        "authorPortrait": "头像",
        "time": "1493165223"
    ]
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "详情"
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
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        tableView?.allowsSelection = false
    }
}

extension MessageDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = MessageCell()
            cell.initUI(portraitImage: UIImage(named: data["portrait"]!), username: "\(data["username"]!)[\(data["label"]!)]", time: data["time"]!, detail: data["sign"]!)
            cell.timeLabel.isHidden = true
            return cell
        case 1:
            let cell = UITableViewCell()
            let detaillabel = UILabel(text: data["detail"]!, fontSize: 16)
            cell.contentView.addSubview(detaillabel)
            detaillabel.snp.makeConstraints {
                make in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
            detaillabel.numberOfLines = 0
            
            let postLabel = UILabel(text: "原文：")
            cell.contentView.addSubview(postLabel)
            postLabel.snp.makeConstraints {
                make in
                make.top.equalTo(detaillabel.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
            }
            
            let postView = UIView()
            cell.contentView.addSubview(postView)
            postView.snp.makeConstraints {
                make in
                make.top.equalTo(postLabel.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(screenFrame.height*(200/1920))
            }
            postView.backgroundColor = .BBSlightGray
            
            let authorPortraitImageView = UIImageView(image: UIImage(named: data["authorPortrait"]!))
            postView.addSubview(authorPortraitImageView)
            authorPortraitImageView.snp.makeConstraints {
                make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(screenFrame.width*(160/1080))
                make.left.equalToSuperview().offset(16)
            }
            authorPortraitImageView.layer.cornerRadius = screenFrame.width*(160/1080)/2
            authorPortraitImageView.clipsToBounds = true
            
            let postTitleLabel = UILabel(text: data["postTitle"]!)
            postView.addSubview(postTitleLabel)
            postTitleLabel.snp.makeConstraints {
                make in
                make.top.equalTo(authorPortraitImageView.snp.top).offset(8)
                make.left.equalTo(authorPortraitImageView.snp.right).offset(8)
            }
            
            let authorLabel = UILabel(text: "作者:\(data["postAuthor"]!)", color: .darkGray, fontSize: 14)
            postView.addSubview(authorLabel)
            authorLabel.snp.makeConstraints {
                make in
                make.top.equalTo(postTitleLabel.snp.bottom).offset(8)
                make.left.equalTo(authorPortraitImageView.snp.right).offset(8)
                make.right.equalToSuperview().offset(-16)
            }
            
            let timeString = TimeStampTransfer.string(from: data["time"]!, with: "MM-dd")
            let timeLabel = UILabel(text: timeString, color: .lightGray)
            cell.contentView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints {
                make in
                make.top.equalTo(postView.snp.bottom).offset(8)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-8)
            }
            
            //TODO: Input View
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension MessageDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
