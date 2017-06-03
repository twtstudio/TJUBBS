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
import DTCoreText

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
    var pastPageList: [PostModel] = []
    var currentPageList: [PostModel] = []
    var replyView: UIView?
    var replyTextField: UITextField?
    var replyButton: UIButton?
    var anonymousView: UIView?
    var anonymousSwitch: UISwitch?
    var anonymousLabel: UILabel?
    var page = 0
    var tid = 0
    var imageViews = [DTLazyImageView]()
    var cellCache = NSCache<NSString, RichPostCell>()

    var bottomButton: UIButton?
    var refreshFlag = true
    
    convenience init(thread: ThreadModel) {
        self.init()
        self.thread = thread
        print(thread.id)
        self.hidesBottomBarWhenPushed = true
    }
    
    convenience init(tid: Int) {
        self.init()
        self.tid = tid
        self.hidesBottomBarWhenPushed = true
    }
    
    deinit {
        for imageView in imageViews {
            imageView.delegate = nil
        }
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
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refresh))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.load))
        self.tableView.mj_footer.isAutomaticallyHidden = true
        
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
        self.pastPageList = []
        page = 0
        tid = thread?.id ?? tid
        BBSJarvis.getThread(threadID: tid, page: page, failure: { _ in
            if (self.tableView.mj_header.isRefreshing()) {
                self.tableView.mj_header.endRefreshing()
            }
        }) { dict in
            if let data = dict["data"] as? Dictionary<String, Any>,
                let thread = data["thread"] as? Dictionary<String, Any>,
                let posts = data["post"] as? Array<Dictionary<String, Any>>,
                let board = data["board"] as? [String: Any] {
                
                self.board = BoardModel(JSON: board)
                let flag = self.thread == nil // thread nil flag
                self.thread = ThreadModel(JSON: thread)
                self.thread?.boardID = self.board!.id
                self.currentPageList = Mapper<PostModel>().mapArray(JSONArray: posts)
                if flag {
                    self.initUI()
                }
            }
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
            self.loadFlag = false
            self.postList = self.currentPageList + self.pastPageList
            self.tableView.reloadData()
            self.replyView?.setNeedsLayout()
        }
    }
    
    func load() {
        guard refreshFlag == true else {
            return
        }
        self.refreshFlag = false
        if (self.currentPageList.count < 49 && self.page == 0) || (self.currentPageList.count < 50 && self.page != 0) {//request current page again
            
        } else {//request next page
            pastPageList += currentPageList
            currentPageList = []
            page += 1
        }
        BBSJarvis.getThread(threadID: thread!.id, page: page, failure: { _ in
            if (self.tableView.mj_footer.isRefreshing()) {
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            dict in
            if let data = dict["data"] as? [String: Any],
            let posts = data["post"] as? [[String: Any]] {
                self.currentPageList = Mapper<PostModel>().mapArray(JSONArray: posts) 
                if (self.currentPageList.count < 49)&&(self.page == 0) || (self.currentPageList.count < 50)&&(self.page != 0) {
                    HUD.flash(.label("滑到底部了哟🌚"), delay: 0.7)
                }
            }
            if self.tableView.mj_footer.isRefreshing() {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_footer.isAutomaticallyHidden = true
            }
            self.loadFlag = false
            self.postList = self.pastPageList + self.currentPageList
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                self.replyView?.setNeedsLayout()
            }
        }
    }
    
    func loadToBottom() {
        self.pastPageList = []
        page = self.thread!.replyNumber/50
        BBSJarvis.getThread(threadID: thread!.id, page: page, failure: { _ in
            if (self.tableView.mj_footer.isRefreshing()) {
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            dict in
            if let data = dict["data"] as? [String: Any],
            let posts = data["post"] as? [[String: Any]]{
                self.currentPageList = Mapper<PostModel>().mapArray(JSONArray: posts)
            }
            if (self.tableView.mj_footer.isRefreshing()) {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_footer.isAutomaticallyHidden = true
            }
            self.loadFlag = false
            self.postList = self.pastPageList + self.currentPageList
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                self.replyView?.setNeedsLayout()
            }
            if self.tableView.numberOfRows(inSection: 1) != 0 {
                let indexPath = IndexPath(row: (self.tableView.numberOfRows(inSection: 1))-1, section: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
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
        self.title = thread?.title
        tableView.keyboardDismissMode = .interactive
        let bottomHeight = thread?.boardID == 193 ? -80 : -50
        tableView.snp.makeConstraints {
            make in
//            make.bottom.equalToSuperview().offset(-56)
//            make.bottom.equalToSuperview().offset(-80)
            make.bottom.equalToSuperview().offset(bottomHeight)
            make.top.left.right.equalToSuperview()
        }
//        tableView.register(ReplyCell.self, forCellReuseIdentifier: "replyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 340
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        bottomButton = UIButton(imageName: "down")
        view.addSubview(bottomButton!)
        bottomButton?.snp.makeConstraints {
            make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-88)
            make.height.width.equalTo(screenSize.width*(104/1080))
        }
        bottomButton?.alpha = 0
        bottomButton?.addTarget {
            _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomButton?.alpha = 0
            })
            self.loadToBottom()
        }
        
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
            anonymousLabel?.text = "匿名不可用"
        }
        anonymousSwitch = UISwitch()
        anonymousSwitch?.onTintColor = .BBSBlue
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
                make.height.equalTo(32)
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
                BBSJarvis.reply(threadID: self.thread!.id, content: noBBtext, anonymous: self.anonymousSwitch?.isOn ?? false, success: { _ in
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
        let vc = UIActivityViewController(activityItems: [UIImage(named: "头像2")!, "[求实BBS] \(thread!.title)", URL(string: "https://bbs.tju.edu.cn/forum/thread/\(thread!.id)")!], applicationActivities: [])
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
    
    func prepareReplyCellForIndexPath(tableView: UITableView, indexPath: IndexPath, post: PostModel) -> RichPostCell {
        let key = NSString(format: "%ld-%ld-reply", indexPath.section, indexPath.row) // Cache requires NSObject
//        var cell = cellCache.object(forKey: key)
//        if cell == nil {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RichReplyCell-\(indexPath.row)") as? RichPostCell
        if cell == nil {
            cell = RichPostCell(reuseIdentifier: "RichReplyCell-\(indexPath.row)")
        }
        cell?.hasFixedRowHeight = false
        cellCache.setObject(cell!, forKey: key)
        cell?.delegate = self
        cell?.selectionStyle = .none
//        }
        let html = BBCodeParser.parse(string: post.content)
        let option = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      DTDefaultFontSize: 14.0,
                      DTDefaultFontFamily: UIFont.systemFont(ofSize: 14).familyName,
                      DTDefaultFontName: UIFont.systemFont(ofSize: 14).fontName] as [String : Any]
        cell?.setHTMLString(html, options: option)
//        cell?.setHTMLString(html)
        cell?.initUI(post: post)
        cell?.attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell?.attributedTextContextView.shouldDrawImages = true
        return cell!
    }
    
    func prepareCellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> RichPostCell {
//        let key = "\(indexPath.section)-\(indexPath.row)"
//        let key = NSString(format: "%ld-%ld-post", indexPath.section, indexPath.row) // Cache requires NSObject
//        var cell = cellCache.object(forKey: key)
//        if cell == nil {
           var cell = tableView.dequeueReusableCell(withIdentifier: "RichPostCell") as? RichPostCell
            if cell == nil {
                cell = RichPostCell(reuseIdentifier: "RichPostCell")
            }
            cell?.hasFixedRowHeight = false
//            cellCache.setObject(cell!, forKey: key)
            cell?.delegate = self
            cell?.selectionStyle = .none
//        }
        let html = BBCodeParser.parse(string: thread!.content)
//        cell?.setHTMLString(html)
        let option = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                      DTDefaultFontSize: 14.0,
                      DTDefaultFontFamily: UIFont.systemFont(ofSize: 14).familyName,
                      DTDefaultFontName: UIFont.systemFont(ofSize: 14).fontName] as [String : Any]
        cell?.setHTMLString(html, options: option)

        cell?.initUI(thread: self.thread!)
        
        cell?.portraitImageView.addTapGestureRecognizer { _ in
            let detailVC = ImageDetailViewController(image: cell?.portraitImageView.image ?? UIImage(named: "progress")!)
            
            self.modalPresentationStyle = .overFullScreen
            self.present(detailVC, animated: true, completion: nil)
        }

        cell?.attributedTextContextView.edgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        cell?.attributedTextContextView.shouldDrawImages = true
        return cell!
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let cell = tableView.cellForRow(at: indexPath) as? RichPostCell {
//            return cell.requiredRowHeight(in: tableView)
//        }
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            return prepareCellForIndexPath(tableView: tableView, indexPath: indexPath)

        } else {
            let post = postList[indexPath.row]
//            let cell = ReplyCell()
            let cell = prepareReplyCellForIndexPath(tableView: tableView, indexPath: indexPath, post: post)
//            cell.initUI(post: post)
            cell.initUI(post: post)
            cell.portraitImageView.addTapGestureRecognizer { _ in
                let detailVC = ImageDetailViewController(image: cell.portraitImageView.image ?? UIImage(named: "progress")!)
                
                self.modalPresentationStyle = .overFullScreen
                self.present(detailVC, animated: true, completion: nil)
            }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if bottomButton?.alpha == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomButton?.alpha = 0.8
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshFlag = true
        if (self.tableView.mj_footer.isRefreshing()) {
            self.tableView.mj_footer.endRefreshing()
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
        //FIXME: more than 1 page after reply
    }
}
extension ThreadDetailViewController: HtmlContentCellDelegate {
    func htmlContentCell(cell: RichPostCell, linkDidPress link:NSURL) {
        print("tapped")
        print(link)
    }
    func htmlContentCellSizeDidChange(cell: RichPostCell) {
//        if cell.floorLabel.isHidden {
            self.tableView.reloadData()
//        }
        for imgView in cell.imageViews {
            imgView.addTapGestureRecognizer { _ in 
                let detailVC = ImageDetailViewController(image: imgView.image ?? UIImage(named: "progress")!)
                
                self.modalPresentationStyle = .overFullScreen
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
}

//extension ThreadDetailViewController: DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
//    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
//        if let attachment = attachment as? DTImageTextAttachment {
//            let aspectFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
//            let imageView = DTLazyImageView(frame: aspectFrame)
//            
//            imageView.delegate = self
//            imageView.url = attachment.contentURL
//            imageView.contentMode = UIViewContentMode.scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
//            imageView.shouldShowProgressiveDownload = true
//            imageViews.append(imageView)
//            
//            return imageView
//        }
//        return UIView()
////        let imgView = UIImageView(frame: frame)
////        if attachment is DTImageTextAttachment {
////            imgView.kf.setImage(with: ImageResource(downloadURL: attachment.contentURL, cacheKey: attachment.contentURL.absoluteString), placeholder: UIImage(named: "progress"))
////        }
////        return imgView
//    }
//    func lazyImageView(lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
//        
//        let url = lazyImageView.url
//        let pred = NSPredicate(format: "contentURL == %@", url as! CVarArg)
////        
////        var needsNotifyNewImageSize = false
////        if let layoutFrame = self.attributedTextContextView.layoutFrame {
////            var attachments = layoutFrame.textAttachmentsWithPredicate(pred)
////            
////            for i in 0 ..< attachments.count {
////                if let one = attachments[i] as? DTImageTextAttachment {
////                    
////                    if CGSizeEqualToSize(one.originalSize, CGSizeZero) {
////                        one.originalSize = aspectFitImageSize(size)
////                        needsNotifyNewImageSize = true
////                        
////                    }
////                }
////            }
////        }
////        
////        if needsNotifyNewImageSize {
////            self.attributedTextContextView.layouter = nil
////            self.attributedTextContextView.relayoutText()
////            self.delegate?.htmlContentCellSizeDidChange(self)
////        }
//    }
//    
//}
