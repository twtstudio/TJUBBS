//
//  HomepageMainController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import WMPageController

class MyPostHomeViewController: WMPageController {
    convenience init() {
        self.init(viewControllerClasses: [MyThreadsViewController.self, MyPostsViewController.self], andTheirTitles: ["我的主题", "我的回复"])
        self.title = "我的发布"
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
        // 把返回换成空白
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        super.viewDidLoad()
        if BBSUser.shared.isVisitor == false {
            BBSJarvis.getHome(success: nil, failure: {
                _ in
            })
        }
        
    }
}
