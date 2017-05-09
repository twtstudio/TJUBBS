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
    var loadFlag = false
    var tableView = UITableView(frame: .zero, style: .grouped)
    var webView = UIWebView()
    lazy var webViewLoad: Void = {
        //MARK: dangerous thing
        self.webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!))
    }()
    
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
            "time": "1494061223"
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
        return 1
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
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let cell = UITableViewCell()
            let portraitImageView = UIImageView(image: UIImage(named: postDetail["image"]!))
            cell.contentView.addSubview(portraitImageView)
            portraitImageView.snp.makeConstraints {
                make in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(16)
                make.width.height.equalTo(screenSize.height*(80/1920))
            }
            portraitImageView.layer.cornerRadius = screenSize.height*(80/1920)/2
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
                make.top.equalTo(usernameLabel.snp.bottom).offset(8)
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
                button.setImage(UIImage(named: "已收藏"), for: .normal)
            }
            
            cell.contentView.addSubview(webView)
            webView.snp.makeConstraints {
                make in
                make.top.equalTo(portraitImageView.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().offset(-8)
            }
            webView.delegate = self
            _ = webViewLoad
            
            
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

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PostDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let actualSize = webView.sizeThatFits(.zero)
        var newFrame = webView.frame
        newFrame.size.height = actualSize.height
        webView.frame = newFrame
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

