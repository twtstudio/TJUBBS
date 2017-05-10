//
//  ForumListController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ForumListController: UIViewController {
    var collectionView: UICollectionView?
    var forums = ["休闲娱乐", "乡校情谊", "知性感性", "学术交流", "人文艺术", "体育运动", "社会信息", "研究生苑", "站务管理", "敬请期待"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let height = (self.view.bounds.height - 20 - (self.navigationController?.navigationBar.bounds.height)! - (self.tabBarController?.tabBar.bounds.height)!)/CGFloat(forums.count/2)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width)/2, height: height)
//        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom:1, right: 1)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
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
        return forums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionForumCell", for: indexPath)
        cell.backgroundView = UIImageView(image: UIImage(named: "封面"))
        let label = UILabel(text: forums[indexPath.row])
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
        let blVC = BoardListController()
        blVC.boardList.append(BoardModel(boardName: "娱乐", threads: []))
        blVC.forumName = forums[indexPath.row]
        self.navigationController?.pushViewController(blVC, animated: true)
    }
}
