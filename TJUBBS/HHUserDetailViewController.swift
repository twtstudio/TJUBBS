//
//  HHUserDetailViewController.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/4/29.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher
import ObjectMapper
import MJRefresh
import PiwikTracker
import PKHUD

class HHUserDetailViewController: UIViewController {

    //ThreadList TableView
    var tableView: UITableView!
    var threadList: [ThreadModel] = []
    var user: UserWrapper?
    var uid: Int?

    let header = MJRefreshNormalHeader()
    //    let footer = MJRefreshAutoNormalFooter()

    var scrollView: UIScrollView?
    let headerView = NewPersonalPageView(frame: CGRect(x: 0, y: -UIScreen.main.bounds.height * 0.65, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.65))

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //view.backgroundColor = .lightGray
        //FIXME: sadasd
        UIApplication.shared.statusBarStyle = .lightContent
        //self.hidesBottomBarWhenPushed = true
    }

    convenience init(user: UserWrapper) {
        self.init()
        self.user = user
        headerView.loadModel(user: user)
        self.loadDetail()
    }

    convenience init(uid: Int) {
        self.init()
        self.hidesBottomBarWhenPushed = true
        self.uid = uid
        BBSJarvis.getHome(uid: uid, success: { user in
            self.user = user
            self.loadDetail()
            self.headerView.loadModel(user: user)
            self.loadThread()

            if user.recentThreads.count == 0 {
                let NoMoreDataLabel = UILabel(text: "Ta还没有发布过帖子哟", color: .darkGray, fontSize: 14)
                self.tableView.addSubview(NoMoreDataLabel)
                NoMoreDataLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(self.tableView.snp.bottom).offset(80)
                }
            }

            self.tableView.reloadData()
        }, failure: { _ in
            // FIXME: error page

        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadDetail() {
        if let user = user {
            let cacheKey = "\(user.uid ?? 0)"
            if let url = URL(string: BBSAPI.avatar(uid: user.uid ?? 0)) {
                headerView.avatarView.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
                headerView.avatarViewBackground.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default"))
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadModel()
        registerForPreviewing(with: self, sourceView: self.tableView)
        view.backgroundColor = .lightGray
        self.hidesBottomBarWhenPushed = true
    }

    func loadModel() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: UIScreen.main.bounds.height * 0.65, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView!)

        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(NewPersonTableViewCell.self, forCellReuseIdentifier: "NewPersonCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        headerView.setNeedsDisplay()

        headerView.messageButton.addTarget { _ in
            let dialogVC = ChatDetailViewController()
            dialogVC.pal = self.user
            self.navigationController?.pushViewController(dialogVC, animated: true)
        }
        headerView.friendButton.addTarget { _ in
            let alertVC = UIAlertController(title: "发送好友申请", message: "打个招呼", preferredStyle: .alert)
            alertVC.addTextField(configurationHandler: { _ in

            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertVC.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "发送", style: .default) { _ in
                if let textField = alertVC.textFields?[0], let text = textField.text {
                    BBSJarvis.friendRequest(uid: self.user?.uid ?? 0, message: text, type: "post", success: { dic in
                        print(dic)
                        HUD.flash(.label("发送成功~"), onView: self.view, delay: 1.0)
                    })
                }
            }
            alertVC.addAction(confirmAction)
            self.present(alertVC, animated: true, completion: nil)
        }
        self.tableView.addSubview(headerView)

//        //header and footer of MJRefresh
//        let header = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
//        self.tableView!.mj_header = header
//        header?.ignoredScrollViewContentInsetTop = UIScreen.main.bounds.height * 0.65
//        var refreshingImages = [UIImage]()
//        for i in 1...6 {
//            let image = UIImage(named: "鹿鹿\(i)")?.kf.resize(to: CGSize(width: 60, height: 60))
//            refreshingImages.append(image!)
//        }
//        header?.setImages(refreshingImages, duration: 0.2, for: .pulling)
//        header?.stateLabel.isHidden = true
//        header?.lastUpdatedTimeLabel.isHidden = true
//        header?.setImages(refreshingImages, for: .pulling)

        self.headerView.avatarViewBackground.contentMode = .scaleAspectFill
        self.headerView.blackGlassView.contentMode = .scaleAspectFill
        self.headerView.avatarViewBackground.clipsToBounds = true
        self.headerView.blackGlassView.clipsToBounds = true
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    //下拉刷新
//    func refresh() {
//        // 结束刷新
//        if self.tableView.mj_header.isRefreshing {
//            self.tableView.mj_header.endRefreshing()
//        }
//    }

    func loadThread() {
        let page = 0
        let count = user?.recentThreads.count
        let threadGroup = DispatchGroup()
        for index in 0..<count! {
            let tid = user?.recentThreads[index].id
            threadGroup.enter()
            BBSJarvis.getThread(threadID: tid!, page: page, failure: { _ in
                threadGroup.leave()
            }) { dict in
                threadGroup.leave()
                if let data = dict["data"] as? [String: Any],
                    let thread = data["thread"] as? [String: Any] {
                    let gettedThread = ThreadModel(JSON: thread)
                    self.threadList.append(gettedThread!)
                    //self.tableView.reloadData()
                }
            }
        }
        threadGroup.notify(queue: DispatchQueue.main, execute: {
            self.threadList.sort(by: {$0.createTime > $1.createTime})
            self.tableView.reloadData()

        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.always
        self.navigationController?.navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
    }

}

extension HHUserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row != 0 {
            let detailVC = ThreadDetailViewController(thread: user!.recentThreads[indexPath.row - 1])
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension HHUserDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard user?.recentThreads.count != nil else {
            return 0
        }
        var number: Int = 1
        for thread in (user?.recentThreads)! {
            if thread.visibility == 0 {
                number += 1
            }
        }
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.text = "—— 最近动态 ——"
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.flexibleFont(ofBaseSize: 14)
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewPersonCell") as! NewPersonTableViewCell
            var thread = (user?.recentThreads.count != 0 && threadList.isEmpty == true) ? user!.recentThreads[indexPath.row - 1] : threadList[indexPath.row - 1]
            thread.authorName = user!.username!
            thread.authorID = user!.uid!

            cell.loadModel(thread: thread)
            return cell
        }
    }
}

extension HHUserDetailViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) {
            previewingContext.sourceRect = cell.frame
            let detailVC = ThreadDetailViewController(thread: user!.recentThreads[indexPath.row - 1])
            return detailVC
        }
        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

//extension HHUserDetailViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y = -scrollView.contentOffset.y
//        guard y > 0 else {
//            tableView.y = UIScreen.main.bounds.height * 0.65 + 30 + y
//            return
//        }
//        let ratio = self.view.width/(UIScreen.main.bounds.height * 0.65)
//        let height = UIScreen.main.bounds.height * 0.65 + y
//        let width = height*ratio
//        headerView.avatarViewBackground.snp.remakeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.width.equalTo(width)
//            make.centerX.equalTo(headerView.avatarView)
//            make.height.equalTo(height+1)
//        }
//        headerView.blackGlassView.snp.remakeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.centerX.equalTo(headerView.avatarView)
//            make.width.equalTo(width)
//            make.height.equalTo(height+1)
//        }
//        tableView.y = height + 30
//    }
//}
