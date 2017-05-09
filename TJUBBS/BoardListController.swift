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
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.separatorStyle = .none
        tableView?.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BoardListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let square = UIView()
        square.backgroundColor = UIColor.BBSBlue
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage.init(color: UIColor.BBSBlue)
        cell.textLabel?.text = boardList[section].boardName
        cell.textLabel?.textColor = UIColor.BBSBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tlVC = ThreadListController()
        self.navigationController?.pushViewController(tlVC, animated: true)
        
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
        return ThreadCell(type: .none, title: "天津大学2016年下半年领取高水平论文奖励的通知", date: "2017-05-02", author: "yqzhufeng", content: "lksjdlakjsdlkjaslkdjlaksjdlkasjdljaslaskldka;slkd;laskd;lkas;ldk;alskd;laksdhkajshdkjahkdjaslkjdlasjdklsl")
    }
}
