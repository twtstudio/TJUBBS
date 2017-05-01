//
//  MainTabBarController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/1.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var homepageVC: UIViewController?
    var BBSVC: UIViewController?
    var infoVC: UIViewController?
    
    convenience init(para: Int) {
        self.init()
        view.backgroundColor = UIColor.white
        homepageVC = UIViewController()
        homepageVC?.tabBarItem = createBarItem(imageName: "首页")
        homepageVC?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        BBSVC = UIViewController()
        BBSVC?.tabBarItem = createBarItem(imageName: "论坛")
        BBSVC?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        infoVC = UIViewController()
        infoVC?.tabBarItem = createBarItem(imageName: "个人中心")
        infoVC?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        setViewControllers([homepageVC!, BBSVC!, infoVC!], animated: true)
    }
    
    func createBarItem(imageName: String) -> UITabBarItem {
        let image = UIImage.resizedImage(image: UIImage(named: "\(imageName)-2")!, scaledToSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage.resizedImage(image: UIImage(named: "\(imageName)-1")!, scaledToSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysOriginal)
        return UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
    }
}
