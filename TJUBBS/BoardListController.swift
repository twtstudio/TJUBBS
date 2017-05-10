//
//  BoardListController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class BoardListController: UIViewController {
    var forumName: String! = nil
    var tableView: UITableView?
    var boardList: [BoardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = forumName
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView?.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.94, alpha:1.00)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
        tableView?.estimatedRowHeight = 120
        
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BoardListController: UITableViewDelegate {
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
        cell.textLabel?.text = " " + boardList[section].boardName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.BBSBlue
        cell.addTapGestureRecognizer { [weak self] _ in
            let tlVC = ThreadListController()
            tlVC.listName = (self?.boardList[section].boardName)!
            self?.navigationController?.pushViewController(tlVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = PostDetailViewController(para: 1)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension BoardListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return boardList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // preview
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return ThreadCell(type: .none, title: "天津大学2016年下半年领取高水平论文奖励的通知", date: "2017-05-02", author: "yqzhufeng", content: "lksjdlakjsdlkjaslkdjlaksjdlkasjdljaslaskldka;slkd;laskd;lkas;ldk;alskd;laksdhkajshdkjahkdjaslkjdlasjdklsl")
        let cell = ThreadCell(type: .single, title: "天津大学2016年下半年领取高水平论文奖励的通知", date: "2017-05-02", author: "yqzhufeng", content: "你不是真正的快乐 你的笑只是你穿的保护色 你决定不恨了 也决定不爱了 把你的灵魂关在永远锁上的躯壳")
        cell.imgView?.image = UIImage(named: "封面")
        return cell
    }
}
