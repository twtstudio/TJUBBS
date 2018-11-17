//
//  ForumListVC.swift
//  BBS_v3
//
//  Created by 张毓丹 on 2018/3/28.
//  Copyright © 2018年 张毓丹. All rights reserved.

import UIKit
import ObjectMapper
import PiwikTracker

class ForumListViewController: UIViewController {
    //论坛名，论坛里有的板块
    var forumList: [ForumModel] = []
    var forceRefresh = false

    //tableview
    var forumTableView =  UITableView(frame: .zero, style: .grouped)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PiwikTracker.shared.dispatcher.setUserAgent?(DeviceStatus.userAgent)
        PiwikTracker.shared.appName = "bbs.tju.edu.cn/forum"
        PiwikTracker.shared.userID = "[\(BBSUser.shared.uid ?? 0)] \"\(BBSUser.shared.username ?? "unknown")\""
        PiwikTracker.shared.sendView("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBarItem的相关设置，左侧返回置空，写成讨论区，应该把navigationbar变白
        //navigation item
        let item = UIBarButtonItem(title: "讨论区", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        // tableView的相关设置
        forumTableView.delegate = self
        forumTableView.dataSource = self

        self.forumTableView.estimatedSectionHeaderHeight = 0
        self.forumTableView.estimatedSectionFooterHeight = 0

        self.view.addSubview(forumTableView)
        forumTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadCache()
        //发起网络请求
        getForumList()
    }

    func numOfButton(in section: Int) -> Int {
        let boardCount = forumList[section].boards.count
        let lineCount = (CGFloat(boardCount) / 3.0).rounded(.up)
        return max(Int(lineCount), 2)
    }

    func loadCache() {
        BBSCache.retreive(.forumList, from: .caches, as: String.self, success: { str in
            if let forums = Mapper<ForumModel>().mapArray(JSONString: str) {
                self.forceRefresh = true
                self.forumList = forums
                self.forumTableView.reloadData()
            }
        })
    }

    func getForumList() {
        let group = DispatchGroup()

        var tmpForumList: [ForumModel] = []
        BBSJarvis.getForumList { dict in
            if let data = dict["data"] as? [[String: Any]] {
                let forums = Mapper<ForumModel>().mapArray(JSONArray: data)
//                self.forumList = forums
                tmpForumList = forums
                var forumDict: [String: ForumModel] = [:]
                forums.forEach { forum in
                    forumDict[forum.name] = forum
                }
                //请求到以后，接着请求board
                for forum in forums {
                    group.enter()
                    BBSJarvis.getBoardList(forumID: forum.id, failure: { err in
                        group.leave()
                    }, success: { dict in
                        group.leave()
                        if let data = dict["data"] as? [String: Any],
                            let boards = data["boards"] as? [[String: Any]] {
                            for var board in boards {
                                board["forum_name"] = forum.name
                                let newBoard = BoardModel(JSON: board)!
                                forumDict[forum.name]?.boards.append(newBoard)
                            }
                        }
                    })
                }
            }
            
            group.notify(queue: .main, execute: {
                self.forceRefresh = true
                self.forumList = tmpForumList
                self.forumTableView.reloadData()
                BBSCache.store(object: self.forumList.toJSONString(), in: .caches, as: .forumList)
            })
        }
    }

}

extension ForumListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    //tableView datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let buttonHeight = Variables.WIDTH/8
        return buttonHeight * CGFloat(numOfButton(in: indexPath.section))
    }
}

extension ForumListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return forumList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !forceRefresh,
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForumCell\(indexPath.section)") {
            return cell
        }

        let cell = ForumListTableViewCell(style: .default, reuseIdentifier: "ForumCell\(indexPath.section)")

        let forum = forumList[indexPath.section]
        let buttonCount = numOfButton(in: indexPath.section)

        cell.initUI(forumName: forum.name,
                    numButtonInStack: buttonCount,
                    boardArray: forum.boards)
        cell.buttonTapped = { index in
            let board = forum.boards[index - 1]
            let boardVC = ThreadListController(board: board)
            self.navigationController?.pushViewController(boardVC, animated: true)
        }

        // 加载完了，以后利用缓存池里的
        if indexPath.section == self.forumList.count - 1 {
            forceRefresh = false
        }

        return cell
    }
}
