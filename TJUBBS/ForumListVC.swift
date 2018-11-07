//
//  ForumListVC.swift
//  BBS_v3
//
//  Created by 张毓丹 on 2018/3/28.
//  Copyright © 2018年 张毓丹. All rights reserved.

import UIKit
import ObjectMapper
import Alamofire
import PKHUD
import Kingfisher
import SnapKit
import PiwikTracker

/* Layout gloable varible */
//定义屏幕的宽度和高度

class ForumListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //定义cell重用标志
    let reuStr: String = "reuStr"
    var buttonHeight = Variables.screenWidth/8
    //每一个button定义为屏幕高度的八分之一，宽度为屏宽的四分之一

    //论坛名，论坛里有的板块
    var forumList: [ForumModel] = []
    var boardList: [BoardModel] = []
    var forum: ForumModel?
    //每一个cell中相应的board
    var cellBorad: [[BoardModel]] = []
    var group = DispatchGroup()
    
    //一个用于计算行高的测试数组，表明每一个Row的高度应该是heightForButton*rowAarry[index.section]
    //TODO: 这里有一些问题，因为board的个数如何直接决定cell的行高
    var numOfButtonInStack: [Int] = [4, 2, 5, 3, 3, 2, 2, 2]
    
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
        
        //发起网络请求
        getForumList()
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
        //TODO: Cell高度自适应，如果板块数改动可调
        self.forumTableView.estimatedSectionHeaderHeight = 0
        self.forumTableView.estimatedSectionFooterHeight = 0
        //注册cell
        // self.ForumTableView.register(ForumListTableViewCell.self, forCellReuseIdentifier: reuStr)
        //添加subView
        self.view.addSubview(forumTableView)
        forumTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //    网络请求
    func getForumList() {
        let group = DispatchGroup()
        
        BBSJarvis.getForumList { dict in
            if let data = dict["data"] as? [[String: Any]] {
                let forums = Mapper<ForumModel>().mapArray(JSONArray: data)
                self.forumList = forums
                //请求到以后，接着请求board
                for forum in forums {
                    group.enter()
                    BBSJarvis.getBoardList(forumID: forum.id, failure: { err in
                        group.leave()
                    }, success: { dict in
                        group.leave()
                        if let data = dict["data"] as? [String: Any],
                            let boards = data["boards"] as? [[String: Any]] {
                            for board in boards {
                                var boardCopy = board
                                boardCopy["forum_name"] = forum.name
                                let fooBoard = BoardModel(JSON: boardCopy)
                                self.boardList.append(fooBoard!)
                            }
                        }
                 
                    })
                    
                }
                
            }
            
            group.notify(queue: .main, execute: {
                for i in 0..<self.forumList.count{
                    var tempBoard : [BoardModel] = []
                        for board in self.boardList{
                        
                                if board.forumName == self.forumList[i].name{
                               tempBoard.append(board)
                        }
                           
                    }
                    if tempBoard.count >= 1{
                        self.cellBorad.append(tempBoard)
                        tempBoard.removeAll()
                    }
                }
                self.forumTableView.reloadData()
            })
        }
    }
//    func appendCellBoard(boardList: [BoardModel]) -> [[BoardModel]]{
//    }
    
    //tableView datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return buttonHeight * CGFloat(numOfButtonInStack[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ForumListTableViewCell()
        cell.initUI(forumName: forumList[indexPath.section].name,
                    numButtonInStack: numOfButtonInStack[indexPath.section],
                    boardArray: cellBorad[indexPath.section])
        cell.buttonTapped = { index in
            let bid = self.cellBorad[indexPath.section][index - 1].id
            let boardVC = ThreadListController(bid: bid)
            self.navigationController?.pushViewController(boardVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
