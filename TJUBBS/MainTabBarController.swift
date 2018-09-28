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
    var messageVC: UIViewController?
//    var addVC: UIViewController?

    convenience init(para: Int) {
        self.init()
        self.view.backgroundColor = .white

        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .white
//        self.tabBar.tintColor = .red

        // MARK: - 切换首页
//        homepageVC = HomepageMainController(para: 1)
        homepageVC = NewHomePageViewController()
        let homepageNC = UINavigationController(rootViewController: homepageVC!)
        homepageNC.navigationBar.isTranslucent = false
        homepageNC.tabBarItem = createBarItem(imageName: "home")
    
        homepageNC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        BBSVC = ForumListVC()
        let bbcNC = UINavigationController(rootViewController: BBSVC!)
        bbcNC.navigationBar.isTranslucent = false
        BBSVC?.tabBarItem = createBarItem(imageName: "taolunqu")
        BBSVC?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

//        addVC = AddThreadViewController()
//        let addNC = UINavigationController(rootViewController: addVC!)
//        addVC?.tabBarItem = createBarItem(imageName: "消息")
//        addVC?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        messageVC = MessageHomePageViewController(para: 0)
        let messageNC = UINavigationController(rootViewController: messageVC!)
        messageNC.navigationBar.isTranslucent = false
        messageVC?.tabBarItem = createBarItem(imageName: "message")
        messageVC?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        messageVC?.tabBarItem.tag = 2
//        messageVC?.tabBarItem.badgeColor = .red

        infoVC = UserInfoViewController()
//        infoVC?.title = "个人中心"
        let infoNC = UINavigationController(rootViewController: infoVC!)
        infoNC.tabBarItem = createBarItem(imageName: "mine")
        infoNC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        setViewControllers([homepageNC, bbcNC, messageNC, infoNC], animated: true)

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
                    self.tabBar.items![2].badgeValue = "\(count)"
                }
            })
        }
        if item.tag == 2 {
            BBSJarvis.setMessageRead(success: {_ in })
            self.tabBar.items![2].badgeValue = nil
        }
    }

    func createBarItem(imageName: String) -> UITabBarItem {
//        let image = UIImage.resizedImage(image: UIImage(named: "\(imageName)-2")!, scaledToSize: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysOriginal)
//        let selectedImage = UIImage.resizedImage(image: UIImage(named: "\(imageName)-1")!, scaledToSize: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysOriginal)
        let image = UIImage.resizedImage(image: UIImage(named: "\(imageName)-2")!, scaledToSize: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage.resizedImage(image: UIImage(named: "\(imageName)-1")!, scaledToSize: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
        let item = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
        item.image = item.selectedImage?.imageWithColor(color1: .black).withRenderingMode(.alwaysOriginal)
        return item
    }
}
