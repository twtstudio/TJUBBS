//
//  BoardListController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

class BoardListController: UIViewController {
    
    var forum: ForumModel?
    var tableView: UITableView?
    var boardList: [BoardModel] = []
    var threadList: [[ThreadModel]] = []
    
    convenience init(forum: ForumModel) {
        self.init()
        //why this line cause nil forum
        //view.backgroundColor = .white
        self.forum = forum
        tableView = UITableView(frame: .zero, style: .grouped)
        registerForPreviewing(with: self, sourceView: tableView!)
        self.view.addSubview(tableView!)
        tableView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView?.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.94, alpha:1.00)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
        tableView?.estimatedRowHeight = 120

        
        BBSJarvis.getBoardList(forumID: (self.forum?.id)!, success: {
            dict in
            if let data = dict["data"] as? Dictionary<String, Any>,
                let boards = data["boards"] as? Array<Dictionary<String, Any>>{
                for board in boards {
                    var boardCopy = board
                    boardCopy["forum_name"] = self.forum?.name
                    let fooBoard = BoardModel(JSON: boardCopy)
                    self.boardList.append(fooBoard!)
                    
                    //2 threads
                    var fooThreadList: [ThreadModel] = []
                    if let threads = board["threads"] as? Array<Dictionary<String, Any>> {
                        fooThreadList = Mapper<ThreadModel>().mapArray(JSONArray: threads) 
                    }
                    self.threadList.append(fooThreadList)
                }
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
            //            for board in self.boardList {
            //                BBSJarvis.getThreadList(boardID: board.id, page: 0, success: {
            //                    dict in
            //                    print("dict: \(dict)")
            //                    var fooThreadList: [ThreadModel] = []
            //                    if let data = dict["data"] as? Dictionary<String, Any>,
            //                        let threads = data["thread"] as? Array<Dictionary<String, Any>> {
            //                        print("解析啦")
            //                        for i in 0..<threads.count {
            //                            let fooThread = ThreadModel(JSON: threads[i])
            //                            fooThreadList.append(fooThread!)
            //                        }
            //                    }
            //                    print("fooThreadListCount:\(fooThreadList.count)")
            //                    self.threadList.append(fooThreadList)
            //                    //TODO: 有毒啊，商量接口获取两个
            //                    self.tableView?.reloadData()
            //               })
            //            }
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = forum?.name
        
        // 把返回换成空白
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        // 右侧按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addButtonTapped() {
        
        guard BBSUser.shared.token != nil else {
            let alert = UIAlertController(title: "请先登录", message: "BBS需要登录才能发布消息", preferredStyle: .alert)
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
        
        let addVC = AddThreadViewController()
        addVC.selectedForum = self.forum
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
}

extension BoardListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ThreadDetailViewController(thread: threadList[indexPath.section][indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = UITableViewCell()
        let square = UIView()
        square.backgroundColor = UIColor.BBSBlue
        cell.addSubview(square)
        square.snp.makeConstraints { make in
            make.width.equalTo(4)
            make.height.equalTo(17)
            make.centerY.equalTo(cell.textLabel!.snp.centerY)
            make.left.equalTo(cell.contentView).offset(9)
        }
        cell.accessoryType = .disclosureIndicator
        //                    空格是 offset
        cell.textLabel?.text = " " + boardList[section].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.BBSBlue
        cell.addTapGestureRecognizer { [weak self] _ in
            let detailVC = ThreadListController(board: self?.boardList[section])
            //detailVC.listName = (self?.boardList[section].boardName)!
            detailVC.title = (self?.boardList[section].name)!
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

}

extension BoardListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
//        print("boardListCount:\(boardList.count)")
        return boardList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // preview
        if section >= threadList.count {
            return 0
        }
        return threadList[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        return ThreadCell(type: .none, title: "天津大学2016年下半年领取高水平论文奖励的通知", date: "2017-05-02", author: "yqzhufeng", content: "lksjdlakjsdlkjaslkdjlaksjdlkasjdljaslaskldka;slkd;laskd;lkas;ldk;alskd;laksdhkajshdkjahkdjaslkjdlasjdklsl")
//        let cell = ThreadCell(type: .single, title: "天津大学2016年下半年领取高水平论文奖励的通知", date: "2017-05-02", author: "yqzhufeng", content: "你不是真正的快乐 你的笑只是你穿的保护色 你决定不恨了 也决定不爱了 把你的灵魂关在永远锁上的躯壳")
        let thread = threadList[indexPath.section][indexPath.row]
        let cell = ThreadCell(type: .none, title: thread.title, date: String(thread.createTime), author: thread.authorName, content: String.clearBBCode(string: thread.content))
        // TODO: 替换图片 NEXT VERSION
        cell.imgView?.image = UIImage(named: "封面")
        return cell
    }
    
}

extension BoardListController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView?.indexPathForRow(at: location), let cell = tableView?.cellForRow(at: indexPath) {
            previewingContext.sourceRect = cell.frame
            let detailVC = ThreadDetailViewController(thread: threadList[indexPath.section][indexPath.row])
            return detailVC
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

