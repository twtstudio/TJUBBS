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
    //bad way to make navigationBar translucent
    var fooNavigationBarImage: UIImage?
    var fooNavigationBarShadowImage: UIImage?

    convenience init() {
        self.init(viewControllerClasses: [MyThreadsViewController.self, MyPostsViewController.self], andTheirTitles: ["我的主题", "我的回复"])
        self.title = "我的发布"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        let titleLabel = UILabel(text: "我的发布", color: .black, fontSize: 16, weight: UIFontWeightBold)
        self.navigationItem.titleView = titleLabel

        
        UIApplication.shared.statusBarStyle = .lightContent
        // customization for pageController
        pageAnimatable = true
        titleSizeSelected = 16.0
        titleSizeNormal = 15.0
        menuViewStyle = .line
        titleColorSelected = .black
        titleColorNormal = .black
        menuItemWidth = self.view.frame.size.width/2
        bounces = true
        //        menuHeight = 44;
        menuHeight = 35
        menuViewBottomSpace = -(self.menuHeight + 64.0 + 9)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.shadowImage = nil
////        self.navigationController?.navigationBar.
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        fooNavigationBarImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
//        fooNavigationBarShadowImage = self.navigationController?.navigationBar.shadowImage
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fooNavigationBarImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
        fooNavigationBarShadowImage = self.navigationController?.navigationBar.shadowImage
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }

    override func viewDidLoad() {
        hidesBottomBarWhenPushed = true
        menuBGColor = .white
        progressColor = .black
        // 把返回换成空白
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        super.viewDidLoad()
        if BBSUser.shared.isVisitor == false {
            BBSJarvis.getHome(success: nil, failure: {
                _ in
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.setBackgroundImage(fooNavigationBarImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = fooNavigationBarShadowImage

    }

}
