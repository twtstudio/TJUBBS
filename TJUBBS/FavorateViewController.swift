//
//  FavorateViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Kingfisher
import ObjectMapper
class FavorateViewController: UIViewController {
    
    var tableView: UITableView? = UITableView(frame: .zero, style: .grouped)
    var threadList: [ThreadModel] = [] {
        didSet {
            if threadList.count > 0 && containerView.superview != nil {
                containerView.removeFromSuperview()
            } else if threadList.count == 0 && containerView.superview == nil {
                if containerView.subviews.count == 0 {
                    let label = UILabel()
                    label.text = "还没有收藏"
                    label.textColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.00)
                    label.font = UIFont.boldSystemFont(ofSize: 19)
                    containerView.addSubview(label)
                    label.snp.makeConstraints { make in
                        make.centerY.equalTo(containerView)
                        make.centerX.equalTo(containerView)
                    }
                    label.sizeToFit()
                }
                containerView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
                self.view.addSubview(containerView)
                containerView.frame = CGRect(x: 0, y: 60, width: self.view.width, height: 40)
                containerView.sizeToFit()
            }
        }
    }
    let containerView = UIView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        self.title = "我的收藏"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView?.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        tableView?.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        
        let rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(self.editingStateOnChange(sender:)))
        self.navigationItem.rightBarButtonItem = rightItem
        // This is the better way to hide first headerViews
        self.tableView?.contentInset.top = -35
        
        BBSJarvis.getCollectionList {
            dict in
            if let data = dict["data"] as? [[String: Any]] {
                self.threadList = Mapper<ThreadModel>().mapArray(JSONArray: data)
            } else {
                self.threadList = []
            }
            self.tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FavorateViewController {
    func editingStateOnChange(sender: UIBarButtonItem) {
        tableView?.setEditing(!(tableView?.isEditing)!, animated: true)
        if (tableView?.isEditing)! {
            self.navigationItem.rightBarButtonItem?.title = "完成"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "编辑"
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let thread = threadList[indexPath.row]
        BBSJarvis.deleteCollect(threadID: thread.id, success: { _ in
        })
        threadList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}

extension FavorateViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
     
        var thread = threadList[indexPath.row]
        thread.inCollection = true
        cell.initUI(thread: thread)

        return cell
    }
    
}

extension FavorateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = ThreadDetailViewController(thread: threadList[indexPath.row])
        detailVC.thread = threadList[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
