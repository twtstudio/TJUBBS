//
//  MainTabBarController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/1.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var homepageVC = NewHomePageViewController()
    var BBSVC = ForumListViewController()
    var infoVC = NewUserInfoViewController()
    var messageVC = MessageHomePageViewController(para: 0)
    var addVC = NewAddThreadViewController()

    convenience init(para: Int) {
        self.init()
        self.view.backgroundColor = .white

        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .white
//        self.tabBar.tintColor = .red

        // MARK: - 切换首页
//        homepageVC = HomepageMainController(para: 1)
        let homepageNC = UINavigationController(rootViewController: homepageVC)
        homepageNC.navigationBar.isTranslucent = false
        homepageNC.tabBarItem = createBarItem(imageName: "home")
        homepageNC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let bbcNC = UINavigationController(rootViewController: BBSVC)
        bbcNC.navigationBar.isTranslucent = false
        BBSVC.tabBarItem = createBarItem(imageName: "taolunqu")
        BBSVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let addNC = UINavigationController(rootViewController: addVC)
        addVC.tabBarItem = createBarItem(imageName: "send")
        addVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let messageNC = UINavigationController(rootViewController: messageVC)
        messageNC.navigationBar.isTranslucent = false
        messageVC.tabBarItem = createBarItem(imageName: "message")
        messageVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        messageVC.tabBarItem.tag = 2
//        messageVC?.tabBarItem.badgeColor = .red

//        infoVC?.title = "个人中心"
        let infoNC = UINavigationController(rootViewController: infoVC)
        infoNC.tabBarItem = createBarItem(imageName: "mine")
        infoNC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        setViewControllers([homepageNC, bbcNC, addNC, messageNC, infoNC], animated: true)

        UITabBar.appearance().tintColor = .BBSBlue
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard BBSUser.shared.token != nil else {
            return
        }
//        super.tabBar(tabBar, didSelect: item)
        if item.tag != 2 {
            BBSJarvis.getMessageCount(success: { dict in
                if let count = dict["data"] as? Int, count != 0 {
                    self.tabBar.items?[3].badgeValue = "\(count)"
//                    self.tabBar.items?[2].badgeValue = nil
                }
            })
        }
        if item.tag == 2 {
            BBSJarvis.setMessageRead(success: {_ in })
            self.tabBar.items?[3].badgeValue = nil
        }
    }

    func createBarItem(imageName: String) -> UITabBarItem {
        if imageName == "send" {
            let image = UIImage.resizedImage(image: UIImage(named: "\(imageName)-2")!, scaledToSize: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysOriginal)
            let selectedImage = UIImage.resizedImage(image: UIImage(named: "\(imageName)-1")!, scaledToSize: CGSize(width: 52, height: 52)).withRenderingMode(.alwaysOriginal)
            let item = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
            return item
        } else {
            let image = UIImage.resizedImage(image: UIImage(named: "\(imageName)-2")!, scaledToSize: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysOriginal)
            let selectedImage = UIImage.resizedImage(image: UIImage(named: "\(imageName)-1")!, scaledToSize: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
            let item = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
            return item
        }
    }
}
