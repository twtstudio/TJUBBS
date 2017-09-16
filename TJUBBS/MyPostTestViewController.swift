//
//  MyPostTestViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/9/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh
import YYText
import Kingfisher

class MyPostTestViewController: UIViewController {
    var tableView: UITableView!
    var commonLabel = YYLabel()
    var posts: [PostModel] = []
    var attributedPosts: [NSAttributedString] = []
    let parser = YYTextSimpleMarkdownParser()
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 340
        
        commonLabel.numberOfLines = 0
        parser.setColorWithBrightTheme()
        commonLabel.textParser = parser

        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        self.tableView.mj_footer.isAutomaticallyHidden = true
        self.tableView.mj_header.beginRefreshing()
    }
    
    func refresh() {
        page = 0
        BBSJarvis.getMyPostList(page: page, failure: { err in
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
        }, success: { posts in
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
            self.posts = posts
            for post in posts {
                self.commonLabel.text = post.content
                if let attributedString = self.commonLabel.attributedText?.copy() as? NSAttributedString {
                    self.attributedPosts.append(attributedString)
                }
//                let layout = YYTextLayout(containerSize: CGSize(width: 280, height: CGFloat.greatestFiniteMagnitude), text: label.attributedText!)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func load() {
        page += 1
        BBSJarvis.getMyPostList(page: page, failure: { err in
            if self.tableView.mj_footer.isRefreshing() {
                self.tableView.mj_footer.endRefreshing()
            }
            self.page -= 1
        }, success: { posts in
            if self.tableView.mj_footer.isRefreshing() {
                self.tableView.mj_footer.endRefreshing()
            }
            if self.posts.count == 0 {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.posts += posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

}

extension MyPostTestViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return attributedPosts.count
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "indexPath")
        let label = YYLabel()
        label.numberOfLines = 0
        
        if attributedPosts.count <= indexPath.row {
            let post = posts[indexPath.row].content
            
            let mu = NSMutableAttributedString(string: post)
            let regex = try? NSRegularExpression(pattern: "!\\[\\](\\(attach:(\\d+)\\))", options: .init(rawValue: 0))
            regex?.enumerateMatches(in: post, options: .init(rawValue: 0), range: NSMakeRange(0, post.characters.count), using: { result, flag, stop in
                if let result = result {
                    let r = result.range
                    let attachString = (post as NSString).substring(with: r)
                    let number = attachString.replacingOccurrences(of: "!\\[\\]\\(attach:(\\d+)\\)", with: "$1", options: .regularExpression, range: nil)
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                    imgView.kf.setImage(with: ImageResource(downloadURL: URL(string: "https://bbs.tju.edu.cn/api/img/"+number)!), placeholder: UIImage.init(color: .red)!, options: nil, progressBlock: { (received, expected) in
                        print("\(received)/\(expected)")
                    }, completionHandler: { (image, error, type, url) in
                        if let image = image {
                            //                        imgView.image = image
                            let width = image.size.width
                            if width > 250 {
                                let ratio = width/250
                                imgView.frame.size = CGSize(width: 250, height: image.size.height/ratio)
                            } else {
                                imgView.frame.size = image.size
                                self.tableView.reloadData()
                            }
                        }
                    })
                    let aString = NSAttributedString.yy_attachmentString(withContent: imgView, contentMode: .center, attachmentSize: imgView.frame.size, alignTo: label.font, alignment: .center)
                    mu.replaceCharacters(in: r, with: aString)
                }
            })
            label.attributedText = mu
            self.attributedPosts.append(mu)
        }
        label.attributedText = attributedPosts[indexPath.row]
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().offset(-10)
        }
        return cell
    }
}
