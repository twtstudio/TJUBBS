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
    var thread: ThreadModel?
    var postList: [PostModel] = []
    var replyView: UIView?
    var replyTextField: UITextField?
    var replyButton: UIButton?
    
    convenience init(thread: ThreadModel) {
        self.init()
        self.thread = thread
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
        initUI()
        becomeKeyboardObserver()
        
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        refresh()
    }
    
    func refresh() {
        BBSJarvis.getThread(threadID: thread!.id, page: 0) {
            dict in
            print(dict)
            if let data = dict["data"] as? Dictionary<String, Any>,
                let thread = data["thread"] as? Dictionary<String, Any>,
                let posts = data["post"] as? Array<Dictionary<String, Any>> {
                
                self.thread = ThreadModel(JSON: thread)
                self.postList = Mapper<PostModel>().mapArray(JSONArray: posts) ?? []
            }
            self.loadFlag = false
            self.tableView.reloadData()
        }
    }
    
    func reloadPosts() {
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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loadFlag == true {
            reloadPosts()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            make in
//            make.bottom.equalToSuperview().offset(-56)
            make.bottom.equalToSuperview().offset(-45)
            make.top.left.right.equalToSuperview()
        }
        tableView.register(PostCell.self, forCellReuseIdentifier: "postCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        replyView = UIView()
        view.addSubview(replyView!)
        replyView?.snp.makeConstraints {
            make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        replyView?.backgroundColor = .white
        
        replyTextField = UITextField()
        replyView?.addSubview(replyTextField!)
        replyTextField?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(screenSize.width*(820/1080))
            make.bottom.equalToSuperview().offset(-8)
        }
        replyTextField?.borderStyle = .roundedRect
        replyTextField?.returnKeyType = .done
        replyTextField?.delegate = self
        
        replyButton = UIButton.confirmButton(title: "回复")
        replyView?.addSubview(replyButton!)
        replyButton?.snp.makeConstraints {
            make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(replyTextField!.snp.right).offset(4)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-8)
        }
        replyButton?.addTarget(withBlock: {_ in
            if let text = self.replyTextField?.text, text != "" {
                BBSJarvis.reply(threadID: self.thread!.id, content: text, success: { _ in
                    HUD.flash(.success)
                    self.replyTextField?.text = ""
                    self.reloadPosts()
                })
                self.dismissKeyboard()
            } else {
                HUD.flash(.label("内容不能为空"))
            }
        })
    }
    
    func share() {
        let vc = UIActivityViewController(activityItems: [UIImage(named: "头像2")!, "来BBS玩呀", URL(string: "https://bbs.twtstudio.com/")!], applicationActivities: [])
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
            
            let usernameLabel = UILabel(text: thread!.authorName)
            cell.contentView.addSubview(usernameLabel)
            usernameLabel.snp.makeConstraints {
                make in
                make.top.equalTo(portraitImageView)
                make.left.equalTo(portraitImageView.snp.right).offset(8)
            }
            
            let timeString = TimeStampTransfer.string(from: String(thread!.createTime), with: "yyyy-MM-dd")
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
        if indexPath.section == 0 {
            let replyVC = ReplyViewController(thread: thread)
            self.navigationController?.pushViewController(replyVC, animated: true)
        } else if indexPath.section == 1 {
            let replyVC = ReplyViewController(thread: thread, post: postList[indexPath.row])
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
