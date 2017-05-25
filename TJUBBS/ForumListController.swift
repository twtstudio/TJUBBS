//
//  ForumListController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import PKHUD

class ForumListController: UIViewController {
    var collectionView: UICollectionView?
    //    var forums = ["休闲娱乐", "乡校情谊", "知性感性", "学术交流", "人文艺术", "体育运动", "社会信息", "研究生苑", "站务管理", "敬请期待"]
    var forumList: [ForumModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let height = (self.view.bounds.height - 20 - (self.navigationController?.navigationBar.bounds.height)! - (self.tabBarController?.tabBar.bounds.height)!)/5.0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width)/2, height: height)
        //        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom:1, right: 1)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionForumCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
        // navigationBar 用
        self.title = "论坛区"
        // tabBar 用
        self.tabBarItem.title = ""
        
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        print("ForumList")
        //        BBSJarvis.getForumList(success: {
        //            dict in
        //            print("dict: \(dict)")
        //            if let data = (dict["data"] as? Array<Dictionary<String, Any>>) {
        //                self.forumList = Mapper<ForumModel>().mapArray(JSONArray: data) ?? []
        //            }
        ////            print("forumListCount: \(self.forumList.count)")
        ////            print("id: \(String(describing: self.forumList[0].id))")
        //            self.collectionView?.reloadData()
        //        })
        HUD.show(.rotatingImage(UIImage(named: "progress")))
        Alamofire.request("https://bbs.twtstudio.com/api/forum").responseJSON(completionHandler: {
            response in
            if let dataI = response.result.value,
                let dict = dataI as? Dictionary<String, AnyObject>,
                let data = dict["data"] as? Array<Dictionary<String, Any>> {
                    print(data)
                    self.forumList = Mapper<ForumModel>().mapArray(JSONArray: data) ?? []
            }
            self.collectionView?.reloadData()
            HUD.hide()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ForumListController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionForumCell", for: indexPath)
        cell.backgroundView = UIImageView(image: UIImage(named: "forumPic"))
        let label = UILabel(text: forumList[indexPath.row].name)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.sizeToFit()
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(cell.contentView.snp.center)
        }
        return cell
    }
    
}

extension ForumListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let blVC = BoardListController(forum: forumList[indexPath.row])
        self.navigationController?.pushViewController(blVC, animated: true)
    }
}
