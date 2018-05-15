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

class MyPostsViewController: UIViewController {
    
    var tableView = UITableView(frame: .zero, style: .grouped)
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
//        let rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(self.editingStateOnChange(sender:)))
//        self.navigationItem.rightBarButtonItem = rightItem
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
//        self.tableView.mj_footer.isAutomaticallyHidden = true
        self.tableView.mj_header.beginRefreshing()
    }
    
    
    func refresh() {
        page = 0
        BBSJarvis.getMyPostList(page: page, failure: { err in
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
        }, success: { posts in
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
            self.postList = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func load() {
        page += 1
        BBSJarvis.getMyPostList(page: page, failure: { err in
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
            }
            self.page -= 1
        }, success: { posts in
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
            }
            if self.postList.count == 0 {
                self.tableView.mj_footer.resetNoMoreData()
            }
            self.postList += posts
            DispatchQueue.main.async {
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
//    func editingStateOnChange(sender: UIBarButtonItem) {
//        tableView.setEditing(tableView.isEditing, animated: true)
//        if tableView.isEditing {
//            self.navigationItem.rightBarButtonItem?.title = "完成"
//        } else {
//            self.navigationItem.rightBarButtonItem?.title = "编辑"
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let post = postList[indexPath.row]
//        postList.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//        BBSJarvis.modifyPost(pid: post.id, type: "delete", success: {
//            self.tableView.reloadData()
//        })
//    }
    
}

extension MyPostsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RichReplyCell") as? RichPostCell
        if cell == nil {
            cell = RichPostCell(style: .default, reuseIdentifier: "RichReplyCell")
        }
        cell?.hasFixedRowHeight = false
        cell?.delegate = self
        var post = postList[indexPath.row]
        if post.anonymous == 0 { // if not anonymous
            post.authorName = BBSUser.shared.username ?? ""
            post.authorNickname = BBSUser.shared.nickname ?? ""
            cell?.portraitImageView.image = BBSUser.shared.avatar
            post.authorID = BBSUser.shared.uid ?? 0
        }
        cell?.load(post: post)
        if post.anonymous == 1 {
            cell?.portraitImageView.image = UIImage(named: "anonymous")
        }
        cell?.moreButton.addTarget { _ in
            let alertVC = UIAlertController()
            let editAction = UIAlertAction(title: "编辑", style: .default, handler: { action in
                let editController = EditDetailViewController()
                let edictNC = UINavigationController(rootViewController: editController)
                editController.title = "修改回复"
                editController.placeholder = post.content
                editController.doneBlock = { [weak editController] string in
                    BBSJarvis.modifyPost(pid: post.id, content: string, type: "put", failure: { _ in
                        HUD.flash(.label("修改失败，请稍后重试"), onView: self.view, delay: 1.2)
                    }, success: {
                        HUD.flash(.label("修改成功"), onView: self.view, delay: 1.2)
                        editController?.cancel(sender: UIBarButtonItem())
                    })
                }
                self.present(edictNC, animated: true, completion: nil)
//                self.navigationController?.pushViewController(editController, animated: true)
            })
            
            let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: { action in
                let deleteAlertVC = UIAlertController(title: "确认删除", message: "真的要删除吗？", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                deleteAlertVC.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "删除", style: .destructive) { _ in
                    BBSJarvis.modifyPost(pid: post.id, type: "delete", failure: { _ in
                        HUD.flash(.label("删除失败，请稍后重试"), onView: self.view, delay: 1.2)
                    }, success: {
                        self.postList.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                        HUD.flash(.label("删除成功"), onView: self.view, delay: 1.2)
                    })
                }
                deleteAlertVC.addAction(confirmAction)
                self.present(deleteAlertVC, animated: true, completion: nil)
            })
            alertVC.addAction(editAction)
            alertVC.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertVC.addAction(cancelAction)
            if let popoverPresentationController = alertVC.popoverPresentationController {
                popoverPresentationController.sourceView = cell?.moreButton
                popoverPresentationController.sourceRect = cell!.moreButton.bounds
            }
            self.present(alertVC, animated: true, completion: nil)
        }
        cell?.attributedTextContextView.setNeedsLayout()
        cell?.attributedTextContextView.layoutIfNeeded()
        cell?.contentView.setNeedsLayout()
        cell?.contentView.layoutIfNeeded()
        return cell!
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

extension MyPostsViewController: HtmlContentCellDelegate {
    func htmlContentCell(cell: RichPostCell, linkDidPress link: URL) {
        //        if let tid = Int(link.absoluteString.replacingOccurrences(of: "(.*?)bbs.tju.edu.cn/forum/thread/(.[0-9]+$)", with: "$2", options: .regularExpression, range: nil)) {
        if let tid = Int(link.absoluteString.replacingOccurrences(of: "^([a-zA-Z://]*?)bbs.tju.edu.cn/forum/thread/([0-9]*)(.*)$", with: "$2", options: .regularExpression, range: nil)) {
            let detailVC = ThreadDetailViewController(tid: tid)
            self.navigationController?.pushViewController(detailVC, animated: true)
            return
        }
        
        if let bid = Int(link.absoluteString.replacingOccurrences(of: "^([a-zA-Z://]*?)bbs.tju.edu.cn/forum/([0-9]*)(.*)$", with: "$2", options: .regularExpression, range: nil)) {
            let detailVC = ThreadListController(bid: bid)
            self.navigationController?.pushViewController(detailVC, animated: true)
            return
        }
        
        let ac = UIAlertController(title: "链接", message: link.absoluteString, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "跳转到 Safari", style: .default) {
            action in
            UIApplication.shared.openURL(link)
        })
        ac.addAction(UIAlertAction(title: "复制到剪贴板", style: .default) {
            action in
            UIPasteboard.general.string = link.absoluteString
            HUD.flash(.labeledSuccess(title: "已复制", subtitle: nil), delay: 1.0)
        })
        ac.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    func htmlContentCellSizeDidChange(cell: RichPostCell) {
        if let _ = tableView.indexPath(for: cell) {
            self.tableView.reloadData()
        }
        
        // imageViewer
        for imgView in cell.imageViews {
            imgView.addTapGestureRecognizer { _ in
                let detailVC = ImageDetailViewController(image: imgView.image ?? UIImage(named: "progress")!)
                detailVC.maximumZoomScale = 2
                detailVC.showSaveBtn = true
                self.modalPresentationStyle = .overFullScreen
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
}
