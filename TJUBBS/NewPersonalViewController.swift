//
//  NewPersonalViewController.swift
//  TJUBBS
//
//  Created by HouQinhan on 2018/3/3.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher
import ObjectMapper
import MJRefresh
import PiwikTracker

class NewPersonalViewController: UIViewController {

    //ThreadList TableView
    var tableView: UITableView!
    var newThreadData: [NewThreadModel]? = []
    var threadList: [ThreadModel] = []

    let header = MJRefreshNormalHeader()
//    let footer = MJRefreshAutoNormalFooter()

    var scrollView: UIScrollView?
    let headerView = NewPersonalPageView(frame: CGRect(x: 0, y: -UIScreen.main.bounds.height * 0.65, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.65))

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        tableView?.contentInset = UIEdgeInsets(top: UIScreen.main.bounds.height * 0.65, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView!)

        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            // Fallback on earlier versions
        }
        tableView?.showsVerticalScrollIndicator = false
        tableView?.register(NewPersonTableViewCell.self, forCellReuseIdentifier: "NewPersonCell")
        tableView?.delegate = self
        tableView?.dataSource = self

        let cacheKey = "\(BBSUser.shared.uid ?? 0)"

        if let url = URL(string: BBSAPI.avatar(uid: BBSUser.shared.uid ?? 0)) {
            headerView.avatarView.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default")) { image, _, _, _ in
                BBSUser.shared.avatar = image
            }

            headerView.avatarViewBackground.kf.setImage(with: ImageResource(downloadURL: url, cacheKey: cacheKey), placeholder: UIImage(named: "default")) { image, _, _, _ in
                BBSUser.shared.avatar = image
            }
        }

        let user = Mapper<UserWrapper>().map(JSON:
            ["uid": BBSUser.shared.uid ?? "0",
            "name": BBSUser.shared.username ?? "求实用户",
            "signature": BBSUser.shared.signature ?? "还没有个性签名",
            "points": BBSUser.shared.points ?? 0,
            "c_post": BBSUser.shared.postCount ?? 0,
            "c_thread": BBSUser.shared.threadCount ?? 0,
            "t_create": BBSUser.shared.tCreate ?? "fuck"])!

        headerView.loadModel(user: user)

        headerView.setNeedsDisplay()

//        headerView.editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)

        self.tableView?.addSubview(headerView)

        //header and footer of MJRefresh
        let header = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView!.mj_header = header
        header?.ignoredScrollViewContentInsetTop = UIScreen.main.bounds.height * 0.65
        var refreshingImages = [UIImage]()
        for i in 1...6 {
            let image = UIImage(named: "鹿鹿\(i)")?.kf.resize(to: CGSize(width: 60, height: 60))
            refreshingImages.append(image!)
        }
        header?.setImages(refreshingImages, duration: 0.2, for: .pulling)
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setImages(refreshingImages, for: .pulling)

        self.headerView.avatarViewBackground.contentMode = .scaleAspectFill
        self.headerView.blackGlassView.contentMode = .scaleAspectFill
        self.headerView.avatarViewBackground.clipsToBounds = true
        self.headerView.blackGlassView.clipsToBounds = true
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)

        if BBSUser.shared.threadCount == 0 {
            var NoMoreDataLabel = UILabel(text: "还没有发布过帖子哟", color: .darkGray, fontSize: 14)
            tableView?.addSubview(NoMoreDataLabel)
            NoMoreDataLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(UIScreen.main.bounds.height * 0.095)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func edit() {
        let detailVC = SetInfoViewController()
        //question
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    //下拉刷新
    @objc func refresh() {
        self.tableView?.reloadData()
        // 结束刷新
        self.tableView?.mj_header.endRefreshing()
    }

}

extension NewPersonalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

}

extension NewPersonalViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return threadList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewPersonCell") as! NewPersonTableViewCell
        if indexPath.row == 0 {
            cell.textLabel?.text = "—— 最近动态 ——"
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .center
        } else {
            if threadList.count == 0 {

            }
        }

        return cell
    }
}
