//
//  HomepageMainController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import WMPageController

class HomepageMainController: WMPageController {
    
    
    //bad way to make navigationBar translucent
    var fooNavigationBarImage: UIImage?
    var fooNavigationBarShadowImage: UIImage?
    
    convenience init?(para: Int) {
        self.init(viewControllerClasses: [LatestThreadViewController.self, EliteThreadViewController.self], andTheirTitles: ["最新动态", "全站十大"])
        self.title = "首 页"
        UIApplication.shared.statusBarStyle = .lightContent
        // customization for pageController
        pageAnimatable = true;
        titleSizeSelected = 16.0;
        titleSizeNormal = 15.0;
        menuViewStyle = .line;
        titleColorSelected = .white;
        titleColorNormal = .white;
        menuItemWidth = self.view.frame.size.width/2;
        bounces = true;
        //        menuHeight = 44;
        menuHeight = 35;
        menuViewBottomSpace = -(self.menuHeight + 64.0 + 9);
    }
    
    override func viewDidLoad() {
        menuBGColor = .BBSBlue
        progressColor = .yellow
        
        // 右侧搜索
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchToggled(sender:)))

        // 左侧发帖
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))

        
        // 把返回换成空白
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        super.viewDidLoad()
        if BBSUser.shared.isVisitor == false {
            BBSJarvis.getHome(success: nil, failure: {
                _ in
            })
        }
        
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
        addVC.hidesBottomBarWhenPushed = true
//        addVC.selectedForum = self.forum
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    

    func searchToggled(sender: UIBarButtonItem) {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fooNavigationBarImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
        fooNavigationBarShadowImage = self.navigationController?.navigationBar.shadowImage
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .BBSBlue), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(fooNavigationBarImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = fooNavigationBarShadowImage
        
    }
}
