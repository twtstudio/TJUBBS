//
//  PostDetailViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit

class PostDetailViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    fileprivate var loadFlag = false
    var tableView = UITableView(frame: .zero, style: .grouped)
    var webView = UIWebView()
    var webViewHeight: CGFloat = 0
//    lazy var webViewLoad: Void = {
//        //MARK: dangerous thing
//        self.webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!))
//    }()
    
    var postDetail = [
        "image": "头像",
        "username": "lln(Elieen)",
        "detail":"http://stackoverflow.com/questions/24170922/creating-custom-tableview-cells-in-swift",
        "time": "1494061223"
    ]
    var replyList = [
        [
            "image": "头像",
            "username": "lln(Elieen)",
            "detail": "The asker of the original question has solved their problem. I am adding this answer as a mini self contained example project for others who are trying to do the same thing.",
            "replyNumber": "20",
            "time": "1494061223",
            "subReply": [
                [
                    "username": "T.S.Eliot",
                    "detail": "We shall not cease from exploration, and the end of all our exploring will be to arrive where we started and know the place for the first time.",
                    "time": "1494061223"
                ],
                [
                    "username": "T.S.Eliot",
                    "detail": "We shall not cease from exploration, and the end of all our exploring will be to arrive where we started and know the place for the first time.",
                    "time": "1494061223"
                ],
            ]
        ],
        [
            "image": "头像",
            "username": "lln(Elieen)",
            "detail": "The asker of the original question has solved their problem. I am adding this answer as a mini self contained example project for others who are trying to do the same thing.",
            "replyNumber": "20",
            "time": "1494061223"
        ],
        [
            "image": "头像",
            "username": "lln(Elieen)",
            "detail": "The asker of the original question has solved their problem. I am adding this answer as a mini self contained example project for others who are trying to do the same thing.",
            "replyNumber": "20",
            "time": "1494061223"
        ]
    ]
    
    
    convenience init(para: Int) {
        self.init()
        self.title = "详情"
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }
}

extension PostDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return replyList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = UITableViewCell()
            let portraitImageView = UIImageView(image: UIImage(named: postDetail["image"]!))
            cell.contentView.addSubview(portraitImageView)
            portraitImageView.snp.makeConstraints {
                make in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(16)
                make.width.height.equalTo(screenSize.height*(120/1920))
            }
            portraitImageView.layer.cornerRadius = screenSize.height*(120/1920)/2
            portraitImageView.clipsToBounds = true
            
            let usernameLabel = UILabel(text: postDetail["username"]!)
            cell.contentView.addSubview(usernameLabel)
            usernameLabel.snp.makeConstraints {
                make in
                make.top.equalTo(portraitImageView)
                make.left.equalTo(portraitImageView.snp.right).offset(8)
            }
            
            let timeString = TimeStampTransfer.string(from: postDetail["time"]!, with: "yyyy-MM-dd")
            let timeLabel = UILabel(text: timeString, fontSize: 14)
            cell.contentView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints {
                make in
                make.top.equalTo(usernameLabel.snp.bottom).offset(4)
                make.left.equalTo(portraitImageView.snp.right).offset(8)
            }
            
            let favorButton = UIButton(imageName: "收藏")
            cell.contentView.addSubview(favorButton)
            favorButton.snp.makeConstraints {
                make in
                make.centerY.equalTo(portraitImageView)
                make.right.equalToSuperview()
                make.width.height.equalTo(screenSize.height*(144/1920))
            }
            favorButton.addTarget { button in
                (button as? UIButton)?.setImage(UIImage(named: "已收藏"), for: .normal)
            }
            
            cell.contentView.addSubview(webView)
            if loadFlag == false {
                webView.snp.makeConstraints {
                    make in
                    make.top.equalTo(portraitImageView.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                    make.bottom.equalToSuperview().offset(-8)
                    make.height.equalTo(300)
                }
                webView.delegate = self
                webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!))
                webView.scrollView.isScrollEnabled = false
                webView.scrollView.bounces = false
            } else {
                webView.snp.remakeConstraints {
                    make in
                    make.top.equalTo(portraitImageView.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                    make.bottom.equalToSuperview().offset(-8)
                    make.height.equalTo(webViewHeight)
                }
            }
            
            return cell
        } else {
            let reply = replyList[indexPath.row]
            let cell = replyCell()
            cell.initUI(portraitImage: UIImage(named: reply["image"]! as! String), username: reply["username"]! as! String, detail: reply["detail"]! as! String, replyNumber: reply["replyNumber"]! as! String, time: reply["time"]! as! String, subReplyList: reply["subReply"] as? Array<Dictionary<String, String>>)
            return cell
        }
    }
    
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
    
}

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PostDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadFlag = true
        let actualSize = webView.sizeThatFits(.zero)
//        var newFrame = webView.frame
//
//        webView.frame = newFrame
//        print("-------------\(newFrame.size.height)")
        webViewHeight = actualSize.height
        print("-------------\(webViewHeight)")
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

