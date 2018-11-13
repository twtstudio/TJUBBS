//
//  RankListViewController.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/11/5.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh
import ObjectMapper

class RankListViewController: UIViewController {

    var tableView = UITableView(frame: .zero, style: .grouped)
    var userList: [UserModel] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        UIApplication.shared.statusBarStyle = .default
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "";
        self.navigationItem.titleView = Variables.setNavBarTitle(title: "排行榜")
        createUI()
    }
    
    func createUI() {
        view.backgroundColor = .lightGray
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RanklistTableViewCell.self, forCellReuseIdentifier: "rankListCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .singleLine
        
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
        tableView.mj_header.beginRefreshing()
    }
    
    func refresh() {
        BBSJarvis.getWeekRankList(success: { dict in
            if let data = dict["data"] as? [String: Any], let weekRankList = data["rank"] as? [[String: Any]] {
                self.userList = Mapper<UserModel>().mapArray(JSONArray: weekRankList)
            }
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
            self.tableView.reloadData()
        }, failure: { _ in
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
        })
    }
}

extension RankListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }

}

extension RankListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = HHUserDetailViewController(uid: userList[indexPath.section].id)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankListCell") as! RanklistTableViewCell
        let data = userList[indexPath.row]
        cell.loadModel(user: data)
        cell.rankLabel.text = "\(indexPath.row + 1)"
        switch indexPath.row {
        case 0:
            cell.rankLabel.textColor = UIColor.BBSRed
            cell.nameLabel.textColor = UIColor.BBSRed
            cell.getPointLabel.textColor = UIColor.BBSRed
        case 1:
            cell.rankLabel.textColor = UIColor.BBSHotOrange
            cell.nameLabel.textColor = UIColor.BBSHotOrange
            cell.getPointLabel.textColor = UIColor.BBSHotOrange
        case 2:
            cell.rankLabel.textColor = UIColor.BBSGold
            cell.nameLabel.textColor = UIColor.BBSGold
            cell.getPointLabel.textColor = UIColor.BBSGold
        default:
            cell.rankLabel.textColor = UIColor.black
            cell.nameLabel.textColor = UIColor.black
            cell.getPointLabel.textColor = UIColor.black
        }
        
        return cell
    }
}
