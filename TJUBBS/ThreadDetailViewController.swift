//
//  ThreadDetailViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/9.
//  Copyright © 2017年 twtstudio. All rights reserved.
//


import UIKit
import ObjectMapper
import Kingfisher
import PKHUD
import MJRefresh
import Alamofire

class ThreadDetailViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate var loadFlag = false
    var webView = UIWebView()
    var webViewHeight: CGFloat = 0
    //    lazy var webViewLoad: Void = {
    //        //MARK: dangerous thing
    //        self.webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!))
    //    }()
    var board: BoardModel?
    var thread: ThreadModel?
    var postList: [PostModel] = []
    var replyView: UIView?
    var replyTextField: UITextField?
    var replyButton: UIButton?
    var anonymousView: UIView?
    var anonymousSwitch: UISwitch?
    var anonymousLabel: UILabel?
    var page = 0
    
    convenience init(thread: ThreadModel) {
        self.init()
        self.thread = thread
        print(thread.id)
        self.hidesBottomBarWhenPushed = true
    }
    
    convenience init(tid: Int) {
        self.init()
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad")
        //        self.title = "详情"
        self.title = thread?.title
        view.backgroundColor = .lightGray
        UIApplication.shared.statusBarStyle = .lightContent
        self.hidesBottomBarWhenPushed = true
        view.addSubview(tableView)
        if thread != nil {
            initUI()
        }
        becomeKeyboardObserver()
        
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        refresh()
    }
    
    func refresh() {
        page = 0
        if let thread = thread {
            BBSJarvis.getThread(threadID: thread.id, page: page, failure: { _ in
                if (self.tableView.mj_header.isRefreshing()) {
                    self.tableView.mj_header.endRefreshing()
                }
            }) {
                dict in
                if let data = dict["data"] as? Dictionary<String, Any>,
                    let thread = data["thread"] as? Dictionary<String, Any>,
                    let posts = data["post"] as? Array<Dictionary<String, Any>>,
                    let board = data["board"] as? [String: Any] {
                    
                    self.board = BoardModel(JSON: board)
                    self.thread = ThreadModel(JSON: thread)
                    self.thread?.boardID = self.board!.id
                    self.postList = Mapper<PostModel>().mapArray(JSONArray: posts) ?? []
                }
                if self.postList.count < 49 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView.mj_footer.isAutomaticallyHidden = true
                }
                if (self.tableView.mj_header.isRefreshing()) {
                    self.tableView.mj_header.endRefreshing()
                }
                self.loadFlag = false
                self.tableView.reloadData()
            }
        }
    }
    
    func load() {
        page += 1
        BBSJarvis.getThread(threadID: thread!.id, page: page) {
            dict in
//            print(dict)
            if let data = dict["data"] as? Dictionary<String, Any>,
                let posts = data["post"] as? Array<Dictionary<String, Any>>{
                for post in posts {
                    if let model = PostModel(JSON: post) {
                        self.postList.append(model)
                    }
                }
                if posts.count < 49 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView.mj_footer.isAutomaticallyHidden = true
                }
            }
            if (self.tableView.mj_footer.isRefreshing()) {
                self.tableView.mj_footer.endRefreshing()
            }
            self.loadFlag = false
//            self.tableView.reloadSections([1], with: .none)
            UIView.performWithoutAnimation {
//                self.tableView.reloadSections([1], with: .none)
//                self.tableView.reloadSections([1], with: .automatic)
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initUI() {
        tableView.keyboardDismissMode = .interactive
        let bottomHeight = thread?.boardID == 193 ? -80 : -50
        tableView.snp.makeConstraints {
            make in
//            make.bottom.equalToSuperview().offset(-56)
//            make.bottom.equalToSuperview().offset(-80)
            make.bottom.equalToSuperview().offset(bottomHeight)
            make.top.left.right.equalToSuperview()
        }
        tableView.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        self.tableView.mj_footer.isAutomaticallyHidden = true
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        
        replyView = UIView()
        view.addSubview(replyView!)
        replyView?.snp.makeConstraints {
            make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        replyView?.backgroundColor = .white
        
        anonymousLabel = UILabel()
//        replyView?.addSubview(anonymousLabel!)
        if thread?.boardID == 193 {
            anonymousLabel?.text = "匿名"
        } else {
            // TODO: 不显示 
            anonymousLabel?.text = "匿名不可用"
        }
        anonymousSwitch = UISwitch()
//        replyView?.addSubview(anonymousSwitch!)
        let anonymousView = UIView()
        anonymousView.addSubview(anonymousLabel!)
        anonymousView.addSubview(anonymousSwitch!)
        replyView?.addSubview(anonymousView)
        anonymousLabel?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
        }
        anonymousSwitch?.snp.makeConstraints {
            make in
            make.centerY.equalTo(anonymousLabel!)
            make.right.equalToSuperview().offset(-16)
        }

        if thread?.boardID == 193 {
            anonymousSwitch?.isEnabled = true
            anonymousView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(24)
            }
        } else {
            anonymousView.alpha = 0
            anonymousView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.height.equalTo(0.1).priority(.high)
            }
            anonymousSwitch?.isEnabled = false
        }
        
        
        replyTextField = UITextField()
        replyView?.addSubview(replyTextField!)
        replyTextField?.snp.remakeConstraints {
            make in
//            make.top.equalTo(anonymousSwitch!.snp.bottom).offset(8)
            make.top.equalTo(anonymousView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(screenSize.width*(820/1080))
            make.bottom.equalToSuperview().offset(-8)
        }
        replyTextField?.borderStyle = .roundedRect
        replyTextField?.returnKeyType = .done
        replyTextField?.delegate = self
        
        replyButton = UIButton.confirmButton(title: "回复")
        replyView?.addSubview(replyButton!)
        replyButton?.snp.remakeConstraints {
            make in
            make.top.equalTo(anonymousView.snp.bottom).offset(8)
            make.left.equalTo(replyTextField!.snp.right).offset(4)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-8)
        }
        replyButton?.addTarget(withBlock: {_ in
            
            guard BBSUser.shared.token != nil else {
                let alert = UIAlertController(title: "请先登录", message: "", preferredStyle: .alert)
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
            
            if let text = self.replyTextField?.text, text != "" {
                let noBBtext = text.replacingOccurrences(of: "[", with: "&#91;").replacingOccurrences(of: "]", with: "&#93;")
                BBSJarvis.reply(threadID: self.thread!.id, content: noBBtext, success: { _ in
                    HUD.flash(.success)
                    self.replyTextField?.text = ""
                    self.didReply()
                })
                self.dismissKeyboard()
            } else {
                HUD.flash(.label("内容不能为空"))
            }
        })
        
    }
    
    func share() {
        let vc = UIActivityViewController(activityItems: [UIImage(named: "头像2")!, "来BBS玩呀", URL(string: "https://bbs.twtstudio.com/forum/thread/\(thread!.id)")!], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
}

extension ThreadDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return postList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = UITableViewCell()
            let portraitImageView = UIImageView()
            let portraitImage = UIImage(named: "头像2")
            let url = URL(string: BBSAPI.avatar(uid: thread!.authorID))
            let cacheKey = "\(thread!.authorID)" + Date.today
            portraitImageView.kf.setImage(with: ImageResource(downloadURL: url!, cacheKey: cacheKey), placeholder: portraitImage)
            cell.contentView.addSubview(portraitImageView)
            portraitImageView.snp.makeConstraints {
                make in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(16)
                make.width.height.equalTo(screenSize.height*(120/1920))
            }
            portraitImageView.layer.cornerRadius = screenSize.height*(120/1920)/2
            portraitImageView.clipsToBounds = true
            
            let usernameLabel = UILabel(text: thread?.authorID != 0 ? thread!.authorName : "匿名用户")
            cell.contentView.addSubview(usernameLabel)
            usernameLabel.snp.makeConstraints {
                make in
                make.top.equalTo(portraitImageView)
                make.left.equalTo(portraitImageView.snp.right).offset(8)
            }
            
            let timeString = TimeStampTransfer.string(from: String(thread!.createTime), with: "yyyy-MM-dd HH:mm")
            let timeLabel = UILabel(text: timeString, fontSize: 14)
            cell.contentView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints {
                make in
                make.top.equalTo(usernameLabel.snp.bottom).offset(4)
                make.left.equalTo(portraitImageView.snp.right).offset(8)
            }
            
            let favorButton = UIButton(imageName: "收藏")
            cell.contentView.addSubview(favorButton)
            favorButton.snp.makeConstraints {
                make in
                make.centerY.equalTo(portraitImageView)
                make.right.equalToSuperview()
                make.width.height.equalTo(screenSize.height*(144/1920))
            }
            favorButton.addTarget { button in
                if let button = button as? UIButton {
                    BBSJarvis.collect(threadID: self.thread!.id) {_ in
                        button.setImage(UIImage(named: "已收藏"), for: .normal)
                        button.tag = 1
                    }
                }
            }
            
            cell.contentView.addSubview(webView)
            if loadFlag == false {
                webView.snp.makeConstraints {
                    make in
                    make.top.equalTo(portraitImageView.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                    make.bottom.equalToSuperview().offset(-8)
                    make.height.equalTo(1)
                }
                webView.delegate = self
                //webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!))
                var content = thread!.content
                content = content.replacingOccurrences(of: "\r", with: "")
                content = content.replacingOccurrences(of: "\\", with: "\\\\")
                content = content.replacingOccurrences(of: "\"", with: "\\\\\"")
                content = content.replacingOccurrences(of: "<", with: "&lt")
                content = content.replacingOccurrences(of: ">", with: "&gt")
                content = content.replacingOccurrences(of: "\n", with: "\\n")
                // replace \\ with \\\\
                // replace " with \\"
                // replace < with &lt;
                // replace > with &gt;
                
                let loadString = "<script src=\"BBCodeParser.js\"></script><script>document.write(BBCode(\"\(content)\"));</script>"
                print(loadString)
                webView.loadHTMLString(loadString, baseURL: URL(fileURLWithPath: Bundle.main.resourcePath!))
                webView.scrollView.isScrollEnabled = false
                webView.scrollView.bounces = false
            } else {
                webView.snp.remakeConstraints {
                    make in
                    make.top.equalTo(portraitImageView.snp.bottom).offset(8)
                    make.left.equalToSuperview().offset(16)
                    make.right.equalToSuperview().offset(-16)
                    make.bottom.equalToSuperview().offset(-8)
                    make.height.equalTo(webViewHeight)
                }
            }
            
            return cell
        } else {
            let post = postList[indexPath.row]
            let cell = ReplyCell()
            cell.initUI(post: post)
            return cell
        }
    }
    
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 300
    //    }
    
}

extension ThreadDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let replyVC = ReplyViewController(thread: thread, post: postList[indexPath.row])
            replyVC.delegate = self
            self.navigationController?.pushViewController(replyVC, animated: true)
        }
    }
}

extension ThreadDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadFlag = true
        let actualSize = webView.sizeThatFits(.zero)
        //        var newFrame = webView.frame
        //
        //        webView.frame = newFrame
        //        print("-------------\(newFrame.size.height)")
        webViewHeight = actualSize.height
//        print("actualSize.height: \(actualSize.height)")
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}

extension ThreadDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == replyTextField {
            textField.text = ""
            self.dismissKeyboard()
        }
        return true
    }
}

//keyboard layout
extension ThreadDetailViewController {
    
    override func becomeKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        //        print("用的是我，口亨～")
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        dismissKeyboard()
//    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo  = notification.userInfo! as Dictionary
        let keyboardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyboardBounds.size.height
        let animations:(() -> Void) = {
            self.replyView?.transform = CGAffineTransform(translationX: 0, y: -deltaY)
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let userInfo  = notification.userInfo! as Dictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            self.replyView?.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
}

extension ThreadDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.superview is UITableViewCell {
            return false
        }
        return true
    }
}

extension ThreadDetailViewController: ReplyViewDelegate {
    func didReply() {
        BBSJarvis.getThread(threadID: self.thread!.id, page: 0) {
            dict in
            print(dict)
            if let data = dict["data"] as? Dictionary<String, Any>,
                let thread = data["thread"] as? Dictionary<String, Any>,
                let posts = data["post"] as? Array<Dictionary<String, Any>> {
                self.thread = ThreadModel(JSON: thread)
                self.postList = Mapper<PostModel>().mapArray(JSONArray: posts) ?? []
            }
            self.loadFlag = false
            self.tableView.reloadSections([1], with: .middle)
            self.tableView.scrollToRow(at: IndexPath(row: self.postList.count-1, section: 1), at: .bottom, animated: false)
        }
    }
}
