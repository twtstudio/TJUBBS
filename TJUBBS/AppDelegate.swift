//
//  AppDelegate.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/4/30.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import PiwikTracker
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = .white

            //Handle NavigationBar Appearance
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]

            //            UserDefaults.standard.set(false, forKey: GUIDEDIDSHOW)
            if let userDidSeeGuide = UserDefaults.standard.value(forKey: GUIDEDIDSHOW) as? Bool, userDidSeeGuide == true {
                BBSUser.load()

                // 如果token不为空
                if let token = BBSUser.shared.token, token != "" {
                    BBSJarvis.getAvatar(success: { image in
                        BBSUser.shared.avatar = image
                    }, failure: { _ in })
                    UserDefaults.standard.set(true, forKey: "noJobMode")
                    let tabBarVC = MainTabBarController(para: 1)
                    tabBarVC.modalTransitionStyle = .crossDissolve
                    window.rootViewController = tabBarVC
                } else {
                    let navigationController = UINavigationController(rootViewController: LoginViewController(para: 1))
                    window.rootViewController = navigationController
                }
            } else {
                let navigationController = UINavigationController(rootViewController: GuideViewController())
                window.rootViewController = navigationController
            }
            //            PiwikTracker.configureSharedInstance(withSiteID: "13", baseURL: URL(string: h"ttps://elf.twtstudio.com/piwik.php")!)
            PiwikTracker.sharedInstance(withSiteID: "13", baseURL: URL(string: "https://elf.twtstudio.com/piwik.php")!)
            PiwikTracker.shared.isPrefixingEnabled = false
            window.makeKeyAndVisible()
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        
//        let detailVC = ThreadDetailViewController()
        let tabBarVC = MainTabBarController(para: 1)
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = .white

            //Handle NavigationBar Appearance
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            BBSUser.load()

            window.rootViewController = tabBarVC

            window.makeKeyAndVisible()
            if let query = url.query {
                if let bid = Int(query.replacingOccurrences(of: "^bid=([0-9]*?)(.*)$", with: "$2", options: .regularExpression, range: nil)) {
                    let detailVC = ThreadListController(bid: bid)
                    (tabBarVC.selectedViewController as? UINavigationController)?.pushViewController(detailVC, animated: true)
                    return true
                } else if let tid = Int(query.replacingOccurrences(of: "^tid=([0-9]*?)(.*)$", with: "$2", options: .regularExpression, range: nil)) {
                    let detailVC = ThreadDetailViewController(tid: tid)
                    (tabBarVC.selectedViewController as? UINavigationController)?.pushViewController(detailVC, animated: true)
                    return true
                } else if let uid = Int(query.replacingOccurrences(of: "^uid=([0-9]*?)(.*)$", with: "$2", options: .regularExpression, range: nil)) {
                    let detailVC = HHUserDetailViewController(uid: uid)
                    (tabBarVC.selectedViewController as? UINavigationController)?.pushViewController(detailVC, animated: true)
                    return true
                }
            }
//            tabBarVC.selectedViewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
