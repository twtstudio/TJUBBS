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
        self.init(viewControllerClasses: [PostListViewController.self, PostListViewController.self], andTheirTitles: ["最新动态", "全站十大"])
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
        menuHeight = 44;
        menuViewBottomSpace = -(self.menuHeight + 64.0);
    }
    
    override func viewDidLoad() {
        menuBGColor = .BBSBlue
        progressColor = .yellow
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fooNavigationBarImage = self.navigationController?.navigationBar.backgroundImage(for: .default)
        fooNavigationBarShadowImage = self.navigationController?.navigationBar.shadowImage
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .BBSBlue), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("不应该呀")
        self.navigationController?.navigationBar.setBackgroundImage(fooNavigationBarImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = fooNavigationBarShadowImage
        
    }
}
