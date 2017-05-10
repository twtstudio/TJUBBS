//
//  ThreadListController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ThreadListController: UIViewController {
    var currentPage = 1
    var threads: [ThreadModel] = []
    var tableView: UITableView! = nil
    var listName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.title = listName

        
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

extension ThreadListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ThreadListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
