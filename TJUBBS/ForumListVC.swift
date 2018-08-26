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
var width = UIScreen.main.bounds.width
var height = UIScreen.main.bounds.height
//每一个button定义为屏幕高度的八分之一，宽度为屏宽的四分之一
//设计给出的图是2.1的比例，但是是安卓的，有待后期优化
var heightForButton = UIScreen.main.bounds.width/8

//实例化一个tabbar对象，为了获取tabbar的高度，用于计算 tablevView的高度
var tabBarVC = MainTabBarController()
var tabBarHeight = tabBarVC.tabBar.frame.size.height

//定义cell重用标志
let reuStr: String = "reuStr"

class ForumListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    var ForumTableView = UITableView(frame: .init(x: 0, y: 0, width: width, height: height - tabBarHeight - 60), style: .grouped)
    //navigation item
    let item = UIBarButtonItem(title: "讨论区", style: UIBarButtonItemStyle.plain, target: self, action: nil)
    
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
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        // tableView的相关设置
        ForumTableView.delegate = self
        ForumTableView.dataSource = self
        //TODO: Cell高度自适应，如果板块数改动可调
        self.ForumTableView.estimatedSectionHeaderHeight = 0
        self.ForumTableView.estimatedSectionFooterHeight = 0
        
        
        //注册cell
        // self.ForumTableView.register(ForumListTableViewCell.self, forCellReuseIdentifier: reuStr)
        //添加subView
        self.view.addSubview(ForumTableView)
    }
    
    //    网络请求
    func getForumList() {
        let group = DispatchGroup()
        
        BBSJarvis.getForumList{ dict in
            if let data = dict["data"] as? Array<Dictionary<String, Any>> {
                let forums = Mapper<ForumModel>().mapArray(JSONArray: data)
                self.forumList = forums
                //请求到以后，接着请求board
                for forum in forums {
                    group.enter()
                    BBSJarvis.getBoardList(forumID: forum.id, failure: { err in
                        group.leave()
                    }, success: { dict in
                        group.leave()
                        if let data = dict["data"] as? Dictionary<String, Any>,
                            let boards = data["boards"] as? Array<Dictionary<String, Any>> {
                            for board in boards {
                                var boardCopy = board
                                boardCopy["forum_name"] = forum.name
                                let fooBoard = BoardModel(JSON: boardCopy)
                                self.boardList.append(fooBoard!)
//                                print("board append finished, #of boardList " + String(self.boardList.count))
                            }
                        }
                       
      // print("break")
                    })
                    
                }
                
            }
            
            group.notify(queue: .main, execute: {
                 print( self.forumList.count)
                 print( self.boardList.count)
              
                
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
                    print(self.cellBorad.count)
                    
                    
                }
            //  print(self.boardList.description)
//                for i in 0 ..< self.forumList.count{
//                    var board : [BoardModel] = []
//                    var count = 0
//                    for j in count ..< self.forumList[i].boardCount + count{
//
//                       board.append(self.boardList[j])
//                        count += self.forumList[i].boardCount
//
//                    }
//                    self.cellBorad.append(board)
//                    board.removeAll()
//                   // print(self.cellBorad[i].description + "\n")
//
//                }
              // print( self.forumList.count)
               // print( self.cellBorad.count)
                self.ForumTableView.reloadData()
            })
        }
    }
//    func appendCellBoard(boardList: [BoardModel]) -> [[BoardModel]]{
//    }
    
    //tableView datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForButton * CGFloat(numOfButtonInStack[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\ntabelViewCell start layout (8cells)")
        let cell = ForumListTableViewCell()
        cell.initUI(forumName: forumList[indexPath.section].name,
                    numButtonInStack: numOfButtonInStack[indexPath.section],
                    boardArray: cellBorad[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}



