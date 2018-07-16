//
//  TodayViewController.swift
//  BBSWidget
//
//  Created by Halcao on 2017/8/18.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import NotificationCenter
import ObjectMapper
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view from its nib.
    }
    
    func viewOnTap(sender: UITapGestureRecognizer) {
        self.extensionContext?.open(URL(string: "openTJUBBS://?tid=\(self.titleLabel.tag)")!, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)

        let threads = BBSCache.getTopThread()
        if threads.count > 0 {
            let random = abs(arc4random().distance(to: 0)) % threads.count
            let thread = threads[random]
            self.titleLabel.text = thread.title
            self.replyLabel.text = "回复 (\(thread.replyNumber))"
            // keep the thread id
            self.titleLabel.tag = thread.id
            print(self.titleLabel.tag)
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            completionHandler(NCUpdateResult.newData)
            return
        }
        // no data
        
        Alamofire.request("https://bbs.tju.edu.cn/api/index", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { response in
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        if let dict = json as? Dictionary<String, AnyObject> {
                            if let err = dict["err"] as? Int, err == 0, let data = dict["data"] as? Dictionary<String, Any>,
                                let hot = data["hot"] as? Array<Dictionary<String, Any>> {
                                let threadList = Mapper<ThreadModel>().mapArray(JSONArray: hot)
                                BBSCache.saveTopThread(threads: threadList)
                                let random = abs(arc4random().distance(to: 0)) % threadList.count
                                let thread = threadList[random]
                                self.titleLabel.text = thread.title
                                self.replyLabel.text = "回复 (\(thread.replyNumber))"
                                // keep the thread id
                                self.titleLabel.tag = thread.id
                                completionHandler(NCUpdateResult.newData)
                            } else {
                                self.titleLabel.text = "网络错误 请稍后重试..."
                                self.replyLabel.text = ""
                                completionHandler(NCUpdateResult.failed)
                            }
                        }
                    } catch _ {
                        self.titleLabel.text = "网络错误 请稍后重试..."
                        self.replyLabel.text = ""
                        completionHandler(NCUpdateResult.failed)
                        // log.error(error)/
                    }
                }
            case .failure( _):
                self.titleLabel.text = "网络错误 请稍后重试..."
                self.replyLabel.text = ""
                completionHandler(NCUpdateResult.failed)
                // log.error(error)/
            }
        }
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
    }
    
}
