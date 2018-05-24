//
//  ThreadDetailViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit
import ObjectMapper
import Kingfisher
import PKHUD
import MJRefresh
import Alamofire
import DTCoreText
import PiwikTracker

class ThreadDetailViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    var board: BoardModel?
    var thread: ThreadModel?
    var postList: [PostModel] = [] {
        didSet {
            postList = postList.filter { element in
                for username in BBSUser.shared.blackList.keys {
                    if username == element.authorName {
                        return false
                    }
                }
                return true
            }
        }
    }
    var pastPageList: [PostModel] = []
    var currentPageList: [PostModel] = []
    var page = 0
    var tid = 0
    var imageViews = [DTLazyImageView]()
    let defultAvatar = UIImage(named: "default")
    var centerTextView: UIView! = nil
    var headerView: UIView? = nil
    var boardLabel = UILabel()
    var replyButton = FakeTextFieldView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height-64-45, width: UIScreen.main.bounds.size.width, height: 45))
    
    var bottomButton = ExtendedButton(imageName: "down")
    
    var refreshFlag = true
    
    convenience init(thread: ThreadModel) {
        self.init()
        //self.contentInsetAdjustmentBehavior = false
        //        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        self.thread = thread
        print(thread.id)
        self.hidesBottomBarWhenPushed = true
        PiwikTracker.shared.dispatcher.setUserAgent?(DeviceStatus.userAgent)
        PiwikTracker.shared.appName = "bbs.tju.edu.cn/forum/thread/\(thread.id)/page/1"
        PiwikTracker.shared.userID = "[\(BBSUser.shared.uid ?? 0)] \"\(BBSUser.shared.username ?? "unknown")\""
        PiwikTracker.shared.sendView("")
    }
    
    convenience init(tid: Int) {
        self.init(thread: ThreadModel(JSONString: "{\"id\":\(tid)}")!)
        self.tid = tid
        self.hidesBottomBarWhenPushed = true
    }
    
    deinit {
        for imageView in imageViews {
            imageView.delegate = nil
        }
    }
    
    func setNavigationSubview() {
        self.title = self.thread!.category
        centerTextView = UIView()
        var x: CGFloat = 0
        let y: CGFloat = 64
        var width: CGFloat = 0
        var height: CGFloat = 0
        let title = NSString(string: self.thread!.title)
        let titleSize = title.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        width = min(titleSize.width, UIScreen.main.bounds.width-125)
        height = titleSize.height
        x = (UIScreen.main.bounds.width - width)/2
        centerTextView.frame = CGRect(x: x, y: y, width: width, height: height)
        let titleLabel = UILabel()
        titleLabel.tag = 1
        titleLabel.textAlignment = .center
        titleLabel.text = title as String
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: titleSize.height)
        titleLabel.numberOfLines = 1
        centerTextView.addSubview(titleLabel)
        
        boardLabel.text = (self.board?.name ?? "详情" ) + " >"
        boardLabel.addTapGestureRecognizer { _ in
            if let board = self.board {
                let boardVC = ThreadListController(board: board)
                self.navigationController?.pushViewController(boardVC, animated: true)
            }
        }
        boardLabel.font = UIFont.boldSystemFont(ofSize: 16)
        boardLabel.textColor = .white
        boardLabel.sizeToFit()
        boardLabel.width = width
        boardLabel.textAlignment = .center
        self.navigationItem.titleView = boardLabel
        boardLabel.alpha = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIScreen.main.bounds.size.height == 812 {
            self.replyButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height-64-45-34, width: UIScreen.main.bounds.size.width, height: 45)
        } else {
            self.replyButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height-64-45, width: UIScreen.main.bounds.size.width, height: 45)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = thread?.title
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        view.addSubview(tableView)
        //        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        let header = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        var refreshingImages = [UIImage]()
        for i in 1...6 {
            let image = UIImage(named: "鹿鹿\(i)")?.kf.resize(to: CGSize(width: 60, height: 60))
            refreshingImages.append(image!)
        }
        header?.setImages(refreshingImages, duration: 0.2, for: .pulling)
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setImages(refreshingImages, for: .pulling)
        tableView.mj_header = header
        
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        (self.tableView.mj_footer as? MJRefreshAutoStateFooter)?.setTitle("- 这是我的底线 -", for: .idle)
        (self.tableView.mj_footer as? MJRefreshAutoStateFooter)?.setTitle("滑到底部了哟🌝", for: .noMoreData)
        (self.tableView.mj_footer as? MJRefreshAutoStateFooter)?.setTitle("加加加加加载中...", for: .refreshing)
        
        //        //self.tableView.mj_footer.isAutomaticallyHidden = true
        
        tableView.allowsSelection = true
        
        initUI()
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        refresh()
    }
    
    func refresh() {
        self.pastPageList = []
        page = 0
        tid = thread?.id ?? tid
        BBSJarvis.getThread(threadID: tid, page: page, failure: { _ in
            if (self.tableView.mj_header.isRefreshing) {
                self.tableView.mj_header.endRefreshing()
            }
        }) { dict in
            if let data = dict["data"] as? Dictionary<String, Any>,
                let thread = data["thread"] as? Dictionary<String, Any>,
                let posts = data["post"] as? Array<Dictionary<String, Any>>,
                let board = data["board"] as? [String: Any] {
                self.board = BoardModel(JSON: board)
                let titleIsEmpty = self.thread!.title == "" // thread nil flag
                //                let threadNil = self.thread == nil
                self.thread = ThreadModel(JSON: thread)
                self.thread?.boardID = self.board!.id
                if let name = self.board?.name {
                    self.boardLabel.text = name + " >"
                } else {
                    self.boardLabel.text = "详情"
                }
                self.boardLabel.addTapGestureRecognizer { _ in
                    if let board = self.board {
                        let boardVC = ThreadListController(board: board)
                        self.navigationController?.pushViewController(boardVC, animated: true)
                    }
                }
                self.currentPageList = Mapper<PostModel>().mapArray(JSONArray: posts)
                if titleIsEmpty {
                    self.loadTitle()
                }
                
                //                let needRefresh = (self.pastPageList.count + self.currentPageList.count > self.postList.count || self.pastPageList.count == 0) && self.currentPageList.count != 0
                //                if needRefresh {
                self.postList = self.currentPageList + self.pastPageList
                self.tableView.reloadData()
                //                }
                
                //                if threadNil && !needRefresh {
                //                    self.tableView.reloadData()
                //                }
            }
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    func load() {
        guard refreshFlag == true else {
            return
        }
        self.refreshFlag = false
        if (self.currentPageList.count < 49 && self.page == 0) || (self.currentPageList.count < 50 && self.page != 0) {//request current page again
            
        } else {//request next page
            pastPageList += currentPageList
            currentPageList = []
            page += 1
        }
        BBSJarvis.getThread(threadID: thread!.id, page: page, failure: { _ in
            if (self.tableView.mj_footer.isRefreshing) {
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            dict in
            if let data = dict["data"] as? [String: Any],
                let posts = data["post"] as? [[String: Any]] {
                self.currentPageList = Mapper<PostModel>().mapArray(JSONArray: posts) 
            }
            if self.tableView.mj_footer.isRefreshing {
                self.tableView.mj_footer.endRefreshing()
                //                //self.tableView.mj_footer.isAutomaticallyHidden = true
            }
            
            if self.currentPageList.count > 0 && self.postList.count != self.pastPageList.count + self.currentPageList.count {
                self.postList = self.pastPageList + self.currentPageList
                self.tableView.reloadData()
            }
        }
    }
    
    func loadToBottom() {
        self.pastPageList = []
        page = self.thread!.replyNumber/50
        BBSJarvis.getThread(threadID: thread!.id, page: page, failure: { _ in
            if (self.tableView.mj_footer.isRefreshing) {
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            dict in
            if let data = dict["data"] as? [String: Any],
                let posts = data["post"] as? [[String: Any]]{
                self.currentPageList = Mapper<PostModel>().mapArray(JSONArray: posts)
            }
            if (self.tableView.mj_footer.isRefreshing) {
                self.tableView.mj_footer.endRefreshing()
                //                //self.tableView.mj_footer.isAutomaticallyHidden = true
            }
            self.postList = self.pastPageList + self.currentPageList
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 1) > 3 {
                let indexPath = IndexPath(row: (self.tableView.numberOfRows(inSection: 1))-1, section: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    func loadTitle() {
        if let headerView = headerView {
            for view in headerView.subviews {
                if let label = view as? UILabel {
                    label.text = self.thread!.title
                    headerView.frame = CGRect(x: 0, y: 0, width: tableView.width, height: label.height+36)
                }
            }
            self.tableView.reloadData()
        }
        for view in centerTextView.subviews {
            if let titleLabel = view as? UILabel {
                var x: CGFloat = 0
                let y: CGFloat = 64
                var width: CGFloat = 0
                var height: CGFloat = 0
                let title = NSString(string: self.thread!.title)
                let titleSize = title.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
                width = min(titleSize.width, UIScreen.main.bounds.width-125)
                height = titleSize.height
                x = (UIScreen.main.bounds.width - width)/2
                centerTextView.frame = CGRect(x: x, y: y, width: width, height: height)
                titleLabel.tag = 1
                titleLabel.textAlignment = .center
                titleLabel.text = title as String
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                titleLabel.textColor = .white
                titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: titleSize.height)
                titleLabel.numberOfLines = 1
            }
        }
        boardLabel.text = self.board?.name ?? "详情"
    }
    
    func initUI() {
        self.title = thread?.title
        
        if headerView == nil {
            headerView = UIView()
            headerView!.backgroundColor = .white
            // label in header
            let label = UILabel()
            label.text = thread!.title // + "\n"
            label.textColor = .black
            label.textAlignment = .center
            label.text = self.thread!.title
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.numberOfLines = 0
            headerView!.addSubview(label)
            label.sizeToFit()
            label.snp.makeConstraints { make in
                //                make.left.top.right.bottom.equalToSuperview()
                //                make.left.top.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-3)
                make.top.equalToSuperview() 
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
            
            let spaceView = UIView()
            headerView?.addSubview(spaceView)
            spaceView.backgroundColor = tableView.backgroundColor
            spaceView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(6)
            }
            
            let separator = UIView()
            separator.backgroundColor = UIColor(red:0.89, green:0.89, blue:0.90, alpha:1.00)
            headerView?.addSubview(separator)
            separator.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(spaceView.snp.top)
                make.height.equalTo(1)
            }
            
            
            headerView!.frame = CGRect(x: 0, y: 0, width: tableView.width, height: label.height+36)
        }
        
        setNavigationSubview()
        
        
        tableView.keyboardDismissMode = .interactive
        tableView.snp.makeConstraints {
            make in
            make.bottom.equalToSuperview().offset(-45)
            make.top.left.right.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 340
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share(sender:)))
        
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints {
            make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-88)
            make.height.width.equalTo(30)
        }
        bottomButton.alpha = 0
        bottomButton.addTarget {
            _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomButton.alpha = 0
            })
            self.loadToBottom()
        }
        
        self.view.addSubview(replyButton)
        self.view.backgroundColor = .white
        
        replyButton.addTapGestureRecognizer { _ in
            
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "好的", style: .default) {
                    _ in
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    self.present(navigationController, animated: true, completion: nil)
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let editDetailVC = EditDetailViewController()
            let edictNC = UINavigationController(rootViewController: editDetailVC)
            editDetailVC.title = "回复 " + (self.thread?.authorName ?? "")
            editDetailVC.canAnonymous = (self.thread?.anonymous ?? 0) == 1
            editDetailVC.doneBlock = { [weak editDetailVC] string in
                BBSJarvis.reply(threadID: self.thread!.id, content: string, toID: nil, anonymous: editDetailVC?.isAnonymous ?? false, failure: { error in
                    HUD.flash(.label("出错了...请稍后重试"))
                }, success: { _ in
                    HUD.flash(.success)
                    editDetailVC?.cancel(sender: UIBarButtonItem())
                    //                    let _ = self.navigationController?.popViewController(animated: true)
                    self.loadToBottom()
                })
            }
            self.present(edictNC, animated: true, completion: nil)
            //            self.navigationController?.pushViewController(editDetailVC, animated: true)
        }
    }
    
    func share(sender: UIBarButtonItem) {
        let shareVC = UIActivityViewController(activityItems: [UIImage(named: "头像2")!, "[求实BBS] \(thread!.title)", URL(string: "https://bbs.tju.edu.cn/forum/thread/\(thread!.id)")!], applicationActivities: [])
        if let popoverPresentationController = shareVC.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender
            popoverPresentationController.permittedArrowDirections = .up
        }
        self.present(shareVC, animated: true, completion: nil)
    }
}

extension ThreadDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return postList.count
        default:
            return 0
        }
    }
    
    func prepareReplyCellForIndexPath(tableView: UITableView, indexPath: IndexPath, post: PostModel) -> RichPostCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RichReplyCell") as? RichPostCell
        if cell == nil {
            cell = RichPostCell(style: .default, reuseIdentifier: "RichReplyCell")
            //            cell = RichPostCell(reuseIdentifier: "RichReplyCell")
        }
        cell?.hasFixedRowHeight = false
        cell?.delegate = self
        cell?.load(post: post)
        
        let button = cell?.likeButton
        cell?.likeButton.addTarget { [weak button] _ in
            button?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "好的", style: .default) {
                    _ in
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    self.present(navigationController, animated: true, completion: nil)
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            if cell?.likeButton.tag == 1 {
                // 取消点赞
                BBSJarvis.sendPostOpinion(action: "delete", pid: post.id, success: {
                    var newPost = post
                    newPost.likeCount -= 1
                    newPost.isLiked = false
                    if let index = self.postList.index(where: { post.id == $0.id }) {
                        self.postList.remove(at: index)
                        self.postList.insert(newPost, at: index)
                        cell?.load(post: newPost)
                    }
                }, failure: { errMsg in
                    HUD.flash(.label(errMsg), delay: 1.2)
                })
            } else {
                // 点赞
                BBSJarvis.sendPostOpinion(action: "like", pid: post.id, success: {
                    var newPost = post
                    newPost.likeCount += 1
                    newPost.isLiked = true
                    if let index = self.postList.index(where: { post.id == $0.id }) {
                        self.postList.remove(at: index)
                        self.postList.insert(newPost, at: index)
                        cell?.load(post: newPost)
                    }
                }, failure: { errMsg in
                    HUD.flash(.label(errMsg), delay: 1.2)
                })
            }
        }
        
        cell?.moreButton.addTarget { _ in
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "好的", style: .default) {
                    _ in
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    self.present(navigationController, animated: true, completion: nil)
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let alertVC = UIAlertController()
            let copyAction = UIAlertAction(title: "复制", style: .default, handler: { action in
                UIPasteboard.general.string = post.content
                HUD.flash(.label("已复制到剪切板"), delay: 1.2)
            })
            
            alertVC.addAction(copyAction)
            if post.authorID == BBSUser.shared.uid {
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
                            //                            let _ = self.navigationController?.popViewController(animated: true)
                        })
                    }
                    self.present(edictNC, animated: true, completion: nil)
                    //                    self.navigationController?.pushViewController(editController, animated: true)
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
            }
            
            let reportAction = UIAlertAction(title: "举报", style: .destructive, handler: { action in
                HUD.flash(.label("举报成功"), onView: self.view, delay: 1.2)
            })
            let blockAction = UIAlertAction(title: "不看ta的帖子", style: .destructive, handler: { action in
                BBSUser.shared.blackList[post.authorName] = post.authorID
                BBSUser.save()
                HUD.flash(.label("已加入黑名单(可在通用设置中取消)"), onView: self.view, delay: 1.5)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertVC.addAction(reportAction)
            if post.anonymous == 0 && post.authorID != BBSUser.shared.uid {
                alertVC.addAction(blockAction)
            }
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
        if post.anonymous == 1 {
            cell?.portraitImageView.image = UIImage(named: "anonymous")
        } else {
            let url = URL(string: BBSAPI.avatar(uid: post.authorID))
            let cacheKey = "\(post.authorID)" + Date.today
            cell?.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
        }
        return cell!
    }
    
    func prepareCellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> RichPostCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RichPostCell") as? RichPostCell
        if cell == nil {
            cell = RichPostCell(style: .default, reuseIdentifier: "RichPostCell")
        }
        cell?.hasFixedRowHeight = false
        cell?.delegate = self
        cell?.selectionStyle = .none
        
        
        cell?.load(thread: self.thread!, boardName: board?.name ?? "")
        
        cell?.attributedTextContextView.setNeedsLayout()
        cell?.attributedTextContextView.layoutIfNeeded()
        cell?.contentView.setNeedsLayout()
        cell?.contentView.layoutIfNeeded()
        
        let button = cell?.likeButton
        cell?.likeButton.addTarget { [weak button] _ in
            button?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "好的", style: .default) {
                    _ in
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    self.present(navigationController, animated: true, completion: nil)
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            if self.thread!.isLiked {
                // 取消点赞
                BBSJarvis.sendThreadOpinion(action: "delete", tid: self.thread!.id, success: {
                    self.thread?.isLiked = false
                    self.thread?.likeCount -= 1
                    cell?.load(thread: self.thread!, boardName: self.board?.name ?? "")
                }, failure: { errMsg in
                    HUD.flash(.label(errMsg), delay: 1.2)
                })
            } else {
                // 点赞
                BBSJarvis.sendThreadOpinion(action: "like", tid: self.thread!.id, success: {
                    self.thread?.isLiked = true
                    self.thread?.likeCount += 1
                    cell?.load(thread: self.thread!, boardName: self.board?.name ?? "")
                }, failure: { errMsg in
                    HUD.flash(.label(errMsg), delay: 1.2)
                })
            }
        }
        
        cell?.moreButton.addTarget { _ in
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "好的", style: .default) {
                    _ in
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    self.present(navigationController, animated: true, completion: nil)
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let alertVC = UIAlertController()
            if self.thread!.inCollection {
                let disLikeAction = UIAlertAction(title: "取消收藏", style: .default, handler: { action in
                    BBSJarvis.deleteCollect(threadID: self.thread!.id, success: { _ in
                        HUD.flash(.label("已取消收藏"), onView: self.view, delay: 1.2)
                        self.thread!.inCollection = false
                    })
                })
                alertVC.addAction(disLikeAction)
            } else {
                let likeAction = UIAlertAction(title: "收藏", style: .default, handler: { action in
                    BBSJarvis.collect(threadID: self.thread!.id) { _ in
                        HUD.flash(.label("收藏成功"), onView: self.view, delay: 1.2)
                        self.thread!.inCollection = true
                    }
                })
                alertVC.addAction(likeAction)
            }
            let copyAction = UIAlertAction(title: "复制", style: .default, handler: { action in
                UIPasteboard.general.string = self.thread!.content
                HUD.flash(.label("已复制到剪切板"), delay: 1.2)
            })
            alertVC.addAction(copyAction)
            
            if self.thread!.authorID == BBSUser.shared.uid {
                let editAction = UIAlertAction(title: "编辑", style: .default, handler: { action in
                    let editController = AddThreadViewController()
                    editController.selectedBoard = self.board!
                    editController.tableView.allowsSelection = false
                    editController.title = "修改帖子"
                    editController.placeholderTitle = self.thread!.title
                    editController.placeholder = self.thread!.content
                    editController.doneBlock = { title, content in
                        BBSJarvis.modifyThread(tid: self.thread!.id, content: content, title: title, type: "put", failure: { _ in
                            HUD.flash(.label("修改失败，请稍后重试"), onView: self.view, delay: 1.2)
                        }, success: {
                            HUD.flash(.label("修改成功"), onView: self.view, delay: 1.2)
                            let _ = self.navigationController?.popViewController(animated: true)
                        })
                    }
                    self.navigationController?.pushViewController(editController, animated: true)
                })
                
                let deleteAction = UIAlertAction(title: "删除", style: .destructive, handler: { action in
                    let deleteAlertVC = UIAlertController(title: "确认删除", message: "真的要删除吗？", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    deleteAlertVC.addAction(cancelAction)
                    let confirmAction = UIAlertAction(title: "删除", style: .destructive) { _ in
                        BBSJarvis.modifyThread(tid: self.thread!.id, type: "delete", failure: { _ in
                            HUD.flash(.label("删除失败，请稍后重试"), onView: self.view, delay: 1.2)
                        }, success: {
                            let _ = self.navigationController?.popViewController(animated: true)
                            HUD.flash(.label("删除成功"), delay: 1.2)
                        })
                    }
                    deleteAlertVC.addAction(confirmAction)
                    self.present(deleteAlertVC, animated: true, completion: nil)
                })
                alertVC.addAction(editAction)
                alertVC.addAction(deleteAction)
            }
            
            let reportAction = UIAlertAction(title: "举报", style: .destructive, handler: { action in
                HUD.flash(.label("举报成功"), onView: self.view, delay: 1.2)
            })
            let blockAction = UIAlertAction(title: "不看ta的帖子", style: .destructive, handler: { action in
                if let name = self.thread?.authorName {
                    BBSUser.shared.blackList[name] = self.thread!.authorID
                    BBSUser.save()
                }
                HUD.flash(.label("已加入黑名单(可在通用设置中取消)"), onView: self.view, delay: 1.5)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertVC.addAction(reportAction)
            if self.thread!.anonymous == 0 && self.thread!.authorID != BBSUser.shared.uid {
                alertVC.addAction(blockAction)
            }
            alertVC.addAction(cancelAction)
            if let popoverPresentationController = alertVC.popoverPresentationController {
                popoverPresentationController.sourceView = cell?.moreButton
                popoverPresentationController.sourceRect = cell!.moreButton.bounds
            }
            self.present(alertVC, animated: true, completion: nil)
        }
        
        if thread!.anonymous == 1 {
            cell?.portraitImageView.image = UIImage(named: "anonymous")
        } else {
            let url = URL(string: BBSAPI.avatar(uid: thread!.authorID))
            let cacheKey = "\(thread!.authorID)" + Date.today
            cell?.portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = prepareCellForIndexPath(tableView: tableView, indexPath: indexPath)
            if self.thread?.anonymous == 0 { // exclude anonymous user
                cell.usernameLabel.addTapGestureRecognizer { _ in
                    let userVC = HHUserDetailViewController(uid: self.thread!.authorID)
                    self.navigationController?.pushViewController(userVC, animated: true)
                }
                cell.portraitImageView.addTapGestureRecognizer { _ in
                    let userVC = HHUserDetailViewController(uid: self.thread!.authorID)
                    self.navigationController?.pushViewController(userVC, animated: true)
                }
            }
            return cell
        } else {
            let post = postList[indexPath.row]
            let cell = prepareReplyCellForIndexPath(tableView: tableView, indexPath: indexPath, post: post)
            if post.anonymous == 0 { // exclude anonymous user
                cell.usernameLabel.addTapGestureRecognizer { _ in
                    let userVC = HHUserDetailViewController(uid: post.authorID)
                    self.navigationController?.pushViewController(userVC, animated: true)
                }
                cell.portraitImageView.addTapGestureRecognizer { _ in
                    let userVC = HHUserDetailViewController(uid: post.authorID)
                    self.navigationController?.pushViewController(userVC, animated: true)
                }
            }
            return cell
        }
    }
}

extension ThreadDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView
        }
        return UIView(frame: .zero)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerView?.height ?? 30
        }
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                let confirmAction = UIAlertAction(title: "好的", style: .default) {
                    _ in
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    self.present(navigationController, animated: true, completion: nil)
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let editDetailVC = EditDetailViewController()
            let edictNC = UINavigationController(rootViewController: editDetailVC)
            editDetailVC.title = "回复 " + self.postList[indexPath.row].authorName
            editDetailVC.canAnonymous = (self.thread?.anonymous ?? 0) == 1
            editDetailVC.doneBlock = { [weak editDetailVC] string in
                let post = self.postList[indexPath.row]
                let origin = post.content
                // cut secondary quotation
                let cutString = origin.replacingOccurrences(of: "[\\s]*>[\\s]*>(.|[\\s])*", with: "", options: .regularExpression, range: nil)
                var shortString = cutString
                if cutString.characters.count > 61 {
                    shortString = (cutString as NSString).substring(with: NSMakeRange(0, 60))
                }
                let resultString = string + "\n > 回复 #\(post.floor) \(post.authorName): \n" + shortString.replacingOccurrences(of: ">", with: "> >", options: .regularExpression, range: nil)
                
                BBSJarvis.reply(threadID: self.thread!.id, content: resultString, toID: post.id, anonymous: editDetailVC?.isAnonymous ?? false, failure: { error in
                    HUD.flash(.label("出错了...请稍后重试"))
                }, success: { _ in
                    HUD.flash(.success)
                    editDetailVC?.cancel(sender: UIBarButtonItem())
                    //                    let _ = self.navigationController?.popViewController(animated: true)
                    self.loadToBottom()
                })
            }
            self.present(edictNC, animated: true, completion: nil)
            //            self.navigationController?.pushViewController(editDetailVC, animated: true)
        }
    }
}

extension ThreadDetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offsetY = scrollView.contentOffset.y
        let headerHeight = headerView?.height ?? 30
        
        if velocity.y < 0.1 && velocity.y > -0.1 {
            if offsetY > headerHeight/CGFloat(2.0) && offsetY < headerHeight { // more than half, scroll down
                self.tableView.setContentOffset(CGPoint(x: 0, y: headerHeight), animated: true)
            } else if offsetY < headerHeight/CGFloat(2.0) && offsetY > 0 { // scroll up
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let headerHeight = headerView?.height ?? 30
        let titleHeight = centerTextView.height
        
        let ratio: CGFloat = 0.4
        
        if offsetY <= 0.2 {
            self.navigationItem.titleView = boardLabel
            boardLabel.alpha = 1
        }
        
        if offsetY <= headerHeight*ratio && offsetY > 0.2 {
            let progress = offsetY/(headerHeight*ratio)
            self.navigationItem.titleView = boardLabel
            boardLabel.alpha = 1 - progress
        }
        
        if offsetY > headerHeight*ratio && offsetY < headerHeight {
            self.navigationItem.titleView = centerTextView
            let progress = offsetY - headerHeight*ratio
            self.centerTextView.y = 10 + titleHeight - titleHeight*(progress/(headerHeight*(1-ratio)))
            centerTextView.alpha = progress/headerHeight < 0.17 ? 0 : progress/(headerHeight*(1-ratio))
        }
        
        if offsetY >= headerHeight {
            self.navigationItem.titleView = centerTextView
            centerTextView.alpha = 1
        }
        
        if offsetY > 100 {
            if abs(offsetY-tableView.contentSize.height) < self.view.height {
                if bottomButton.alpha >= 0.8 { // if at the bottom
                    UIView.animate(withDuration: 0.5, animations: {
                        self.bottomButton.alpha = 0
                    })
                }
            } else {
                if bottomButton.alpha == 0 { // if not at the bottom
                    UIView.animate(withDuration: 0.5, animations: {
                        self.bottomButton.alpha = 0.8
                    })
                }
            }
        } else {
            if bottomButton.alpha >= 0.8 { // if
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottomButton.alpha = 0
                })
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshFlag = true
        if (self.tableView.mj_footer.isRefreshing) {
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
}

extension ThreadDetailViewController: HtmlContentCellDelegate {
    func htmlContentCell(cell: RichPostCell, linkDidPress link: URL) {
        if let tid = Int(link.absoluteString.replacingOccurrences(of: "^([a-zA-Z://]*?)bbs.(tju.edu.cn|twtstudio.com)/forum/thread/([0-9]*)(.*)$", with: "$3", options: .regularExpression, range: nil)) {
            let detailVC = ThreadDetailViewController(tid: tid)
            self.navigationController?.pushViewController(detailVC, animated: true)
            return
        }
        
        if let bid = Int(link.absoluteString.replacingOccurrences(of: "^([a-zA-Z://]*?)bbs.(tju.edu.cn|twtstudio.com)/forum/([0-9]*)(.*)$", with: "$3", options: .regularExpression, range: nil)) {
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
        //        if let indexPath = tableView.indexPath(for: cell) {
        if tableView.visibleCells.contains(cell) {
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

