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
import Kingfisher
import SnapKit

class ForumListController: UIViewController {
    var collectionView: UICollectionView?
    //    var forums = ["休闲娱乐", "乡校情谊", "知性感性", "学术交流", "人文艺术", "体育运动", "社会信息", "研究生苑", "站务管理", "敬请期待"]
    var forumList: [ForumModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        let height = (self.view.bounds.height - 20 - (self.navigationController?.navigationBar.bounds.height)! - (self.tabBarController?.tabBar.bounds.height)!)/5.0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width)/2, height: (UIScreen.main.bounds.width)/2)
        //        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom:1, right: 1)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { $0.edges.equalToSuperview() }
        collectionView?.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionForumCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // navigationBar 用
        self.title = "论坛区"
        // tabBar 用
        self.tabBarItem.title = ""
        
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        HUD.show(.rotatingImage(UIImage(named: "progress")))
        BBSJarvis.getForumList() { dict in
            if let data = dict["data"] as? Array<Dictionary<String, Any>> {
                print(data)
                self.forumList = Mapper<ForumModel>().mapArray(JSONArray: data) ?? []
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            HUD.hide()
        }
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
        return (forumList.count % 2 == 1) ? forumList.count + 1 : forumList.count
//        return forumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionForumCell", for: indexPath)
        print(cell.bounds.size)
        cell.backgroundView = UIImageView()
        let url = URL(string: BBSAPI.forumCover(fid: forumList[indexPath.row].id))
        
        (cell.backgroundView as? UIImageView)?.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: "\(indexPath.row)"), placeholder: UIImage(named: "ForumCover\(indexPath.row % 8)"))
        cell.backgroundView?.contentMode = .scaleAspectFill
        let label = UILabel()
        if indexPath.row >= forumList.count {
            label.text = "敬请期待"
        } else {
            label.text = forumList[indexPath.row].name
        }
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.sizeToFit()
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(cell.contentView)
        }
        return cell
    }
    
}

extension ForumListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= forumList.count {
            return
        }
        let blVC = BoardListController(forum: forumList[indexPath.row])
        blVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(blVC, animated: true)
    }
}
