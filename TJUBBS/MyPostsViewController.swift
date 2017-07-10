//
//  MyPostsViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import MJRefresh
import PKHUD
import YYText
import DTCoreText

class MyPostsViewController: UIViewController {
    
    let label = DTAttributedTextContentView()
    var tableView = UITableView(frame: .zero, style: .grouped)
//    let parser = YYTextSimpleMarkdownParser()
    var layouts: [HCRichCellLayout] = []
    var postList: [PostModel] = [] {
        didSet {
            if postList.count > 0 && containerView.superview != nil {
                containerView.removeFromSuperview()
            } else if postList.count == 0 && containerView.superview == nil {
                if containerView.subviews.count == 0 {
                    let label = UILabel()
                    label.text = "你还没有发表过回复呢"
                    label.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
                    label.font = UIFont.boldSystemFont(ofSize: 19)
                    containerView.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.centerY.equalTo(containerView)
                        make.centerX.equalTo(containerView)
                    }
                    label.sizeToFit()
                }
                containerView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
                self.view.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 60, width: self.view.width, height: 40)
                containerView.sizeToFit()
            }
        }
    }
    var page = 0
    var containerView = UIView()
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(108)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(self.editingStateOnChange(sender:)))
        self.navigationItem.rightBarButtonItem = rightItem
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        self.tableView.mj_footer.isAutomaticallyHidden = true
        self.tableView.mj_header.beginRefreshing()
        
        tableView.register(HCRichTextCell.self, forCellReuseIdentifier: "richReplyCell")
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
            var layouts: [HCRichCellLayout] = []
            for post in posts {
                layouts.append(HCRichCellLayout(markdown: post.content, width: self.view.width - 10 - 44 - 8 - 8))
            }
            self.layouts = layouts
            self.postList = posts
            self.tableView.reloadData()
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
            if posts.count == 0 {
                self.tableView.mj_footer.resetNoMoreData()
            } else {
                var layouts: [HCRichCellLayout] = []
                for post in posts {
                    layouts.append(HCRichCellLayout(markdown: post.content, width: self.view.width - 10 - 44 - 8 - 8))
                }
                self.layouts += layouts
                self.postList += posts
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyPostsViewController {
    func editingStateOnChange(sender: UIBarButtonItem) {
        tableView.setEditing(tableView.isEditing, animated: true)
        if tableView.isEditing {
            self.navigationItem.rightBarButtonItem?.title = "完成"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "编辑"
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let post = postList[indexPath.row]
        postList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        BBSJarvis.modifyPost(pid: post.id, type: "delete", success: {
            self.tableView.reloadData()
        })
    }
    
}

extension MyPostsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "richReplyCell") as! HCRichTextCell
//        if cell == nil {
//            cell = HCRichTextCell(style: .default, reuseIdentifier: "richReplyCell")
//        }
        cell.bind(postList[indexPath.row], layout: layouts[indexPath.row].textLayout!)
//        cell.delegate = self
//        cell.tag = row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let layout = layouts[indexPath.row].textLayout!
        return layout.textBoundingRect.size.height + 10 + 44 + 10 + 10
//        return layouts[indexPath.row] + 10 + 10 + 44 + 10
    }
}

extension MyPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tid = postList[indexPath.row].tid
        let detailVC = ThreadDetailViewController(tid: tid)
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

extension MyPostsViewController: ImageSizeChangeDelegate {
    func layoutDidChange(layout: YYTextLayout, row: Int) {
        let old = self.layouts[row]
        old.textLayout = layout
        self.layouts[row] = old
        self.tableView.reloadData()
    }
    
    func sizeDidChange() {
        self.tableView.reloadData()
    }
}
