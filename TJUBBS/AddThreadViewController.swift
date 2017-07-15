//
//  AddThreadViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/15.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import PKHUD
import Marklight

class AddThreadViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var tableView = UITableView(frame: .zero, style: .plain)
    var forumList: [ForumModel] = []
    var boardList: [BoardModel] = []
    var openForumListFlag = false
    var openBoardListFlag = false
    let textView = UITextView()
    let textField = UITextField()
    let textStorage = MarklightTextStorage()
    let bar = UIToolbar()
    var anonymousItems = [UIBarButtonItem]()
    var nonAnonymousItems = [UIBarButtonItem]()
    var imageMap: [Int : Int] = [:]
    var isAnonymous = false
    var canAnonymous = false
    var attachments: [ImageTextAttachment] = []
    var doneBlock: ((String, String)->())?
    var placeholder: String = ""
    var placeholderTitle = ""
    
    var selectedForum: ForumModel? {
        didSet {
            openForumListFlag = false
            forumString = "讨论区: \(selectedForum?.name ?? " ")"
            tableView.reloadSections([0], with: .automatic)
            selectedBoard = nil
        }
    }
    var selectedBoard: BoardModel? {
        didSet {
            openBoardListFlag = false
            boardString = "板块: \(selectedBoard?.name ?? " ")"
            if nonAnonymousItems.count > 0 && anonymousItems.count > 0 {
                if selectedBoard?.id == 193 { //青年湖
                    canAnonymous = true
                    refreshAnonymousState()
                } else {
                    canAnonymous = false
                    refreshAnonymousState()
                }
            }
            tableView.reloadSections([1], with: .automatic)
        }
    }
    var forumString = "讨论区"
    var boardString = "板块"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.title = placeholder == "" ? "发帖" : "修改"
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.backgroundColor = UIColor.BBSLightGray
        tableView.backgroundColor = .white
        
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.frame = CGRect(x: 15, y: 10, width: self.view.width - 30, height: self.view.height-10)
        textView.backgroundColor = .white
        
        // markdown parser
        textStorage.addLayoutManager(textView.layoutManager)
        textView.layoutManager.delegate = self
        textStorage.appendString(placeholder)
        // set the cursor
        textView.selectedRange = NSMakeRange(placeholder.characters.count, 0)
        initBar()
    }

    
    func initBar() {
        let imageButton = UIButton(imageName: "icn_upload")
        imageButton.tintColor = .gray
        imageButton.addTarget { btn in
            // TODO: 拍照
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true) {
                    
                }
            } else {
                HUD.flash(.label("相册不可用🤒请在设置中打开 BBS 的相册权限"), delay: 2.0)
            }
        }
        let imageItem = UIBarButtonItem(customView: imageButton)
        let boldItem = UIBarButtonItem(customView: UIButton(title: "B"))
        let italicItem = UIBarButtonItem(customView: UIButton(title: "I"))
        let headItem = UIBarButtonItem(customView: UIButton(title: "#"))
        let quoteItem = UIBarButtonItem(customView: UIButton(title: "\""))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        nonAnonymousItems = [imageItem, flexibleSpace, boldItem, italicItem, headItem, quoteItem]
        
        bar.items = nonAnonymousItems
        for item in bar.items! {
            if let button = item.customView as? UIButton {
                item.width = 40
                button.width = 40
                button.height = 35
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                button.addTarget(self, action: #selector(self.barButtonTapped(sender:)), for: .touchUpInside)
            }
        }
        
        let anonymousView = UIView()
        let anonymousLabel = UILabel()
        let anonymousSwitch = UISwitch()
        
        anonymousView.addSubview(anonymousLabel)
        anonymousView.addSubview(anonymousSwitch)
        
        anonymousLabel.text = "匿名"
        anonymousLabel.sizeToFit()
        anonymousSwitch.onTintColor = .BBSBlue
        anonymousLabel.snp.makeConstraints {
            make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        anonymousSwitch.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        anonymousSwitch.snp.makeConstraints { make in
            make.left.equalTo(anonymousLabel.snp.right)
            make.bottom.equalToSuperview()
            make.centerY.equalTo(anonymousLabel)
        }
        anonymousView.height = max(anonymousLabel.height, anonymousSwitch.height)
        anonymousView.width = anonymousLabel.width + anonymousSwitch.width
        let anonymousItem = UIBarButtonItem(customView: anonymousView)
        anonymousItem.width = anonymousView.width
        anonymousSwitch.addTarget(self, action: #selector(self.anonymousStateOnChange(sender:)), for: .valueChanged)
        anonymousItems = nonAnonymousItems
        anonymousItems.insert(anonymousItem, at: 1)

        
        if selectedBoard?.id == 193 { //青年湖
            canAnonymous = true
        } else {
            canAnonymous = false
        }
        
        refreshAnonymousState()
    }
    
    func refreshAnonymousState() {
        if canAnonymous {
            bar.items = anonymousItems
        } else {
            bar.items = nonAnonymousItems
        }
    }
    
    func barButtonTapped(sender: UIButton) {
        if let title = sender.titleLabel?.text {
            switch title {
            case "B":
                //                textStorage.appendString("****")
                textStorage.replaceCharacters(in: textView.selectedRange, with: "****")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+2, 0)
            case "I":
                //                textStorage.appendString("**")
                textStorage.replaceCharacters(in: textView.selectedRange, with: "**")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
            case "#":
                textStorage.replaceCharacters(in: textView.selectedRange, with: "#")
                //                textStorage.appendString("#")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
            case "\"":
                textStorage.replaceCharacters(in: textView.selectedRange, with: ">")
                //                textStorage.appendString(">")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
            default:
                break
            }
        }
    }
    
    func anonymousStateOnChange(sender: UISwitch) {
        isAnonymous = sender.isOn
    }

    
    func doneButtonTapped() {
        guard let board = selectedBoard else {
            HUD.flash(.label("请选择板块"))
            return
        }
        
        guard let title = textField.text, !title.isEmpty else {
            HUD.flash(.label("请填写主题"))
            return
        }
        let fullRange = NSMakeRange(0, textStorage.length)
        let resultString = NSMutableAttributedString(attributedString: textStorage.attributedSubstring(from: fullRange))
        var isUploading = false
        textStorage.enumerateAttributes(in: fullRange, options: .reverse, using: { attributes, range, stop in
            if let attribute = attributes["NSAttachment"] as? NSTextAttachment, let image = attribute.image {
                // get the code
                if let code = imageMap[image.hash] {
                    let text = "![](attach:\(code))"
                    resultString.replaceCharacters(in: range, with: text)
                } else {
                    // uploading
                    isUploading = true
                    HUD.flash(.label("上传中...请稍后发布😃"), delay: 1.0)
                }
            }
        })
        if !isUploading {
            if !resultString.string.isEmpty {
                let content = resultString.string
                if let done = doneBlock{
                    done(title, content)
                } else {
                    BBSJarvis.postThread(boardID: board.id, title: title, anonymous: isAnonymous, content: content) { dic in
                        HUD.flash(.success)
                        let _ = self.navigationController?.popViewController(animated: true)
                        if let data = dic["data"] as? [String : Any], let tidStr = data["id"] as? String, let tid = Int(tidStr) {
                            let threadVC = ThreadDetailViewController(tid: tid)
                            self.navigationController?.pushViewController(threadVC, animated: true)
                        }
                    }
                }
            } else {
                HUD.flash(.label("不可以发布空白贴哦👀"), delay: 1.0)
            }
        }
    }
}

extension AddThreadViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 + (openForumListFlag ? forumList.count : 0)
        case 1:
            return 1 + (openBoardListFlag ? boardList.count : 0)
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = forumString
                if let board = selectedBoard {
                    cell.textLabel?.text = "讨论区: " + board.forumName
                }
                
                let rightImageView = UIImageView(image: UIImage(named: openForumListFlag ? "upArrow" : "downArrow"))
                cell.contentView.addSubview(rightImageView)
                rightImageView.snp.makeConstraints {
                    make in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-16)
                    make.height.width.equalTo(15)
                }
                
                // if there's default value for the cell
                if tableView.allowsSelection {
                    cell.addTapGestureRecognizer {
                        sender in
                        self.textView.resignFirstResponder()
                        if self.openForumListFlag == false {
                            BBSJarvis.getForumList {
                                dict in
                                self.openForumListFlag = true
                                if let data = dict["data"] as? [[String: Any]] {
                                    self.forumList = Mapper<ForumModel>().mapArray(JSONArray: data)
                                }
                                var indexPathArray: [IndexPath] = []
                                for i in 1...self.forumList.count {
                                    indexPathArray.append(IndexPath(row: i, section: 0))
                                }
                                tableView.reloadSections([0], with: .none)
                            }
                        } else {
                            self.openForumListFlag = false
                            tableView.reloadSections([0], with: .automatic)
                        }
                    }
                }
                rightImageView.isHidden = !tableView.allowsSelection
                cell.isUserInteractionEnabled = tableView.allowsSelection
                
                let separator = UIView()
                cell.contentView.addSubview(separator)
                separator.backgroundColor = .gray
                separator.alpha = 0.5
                separator.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(0.2)
                }

                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "normalCell")
                cell.textLabel?.text = forumList[indexPath.row-1].name
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = boardString
                
                let rightImageView = UIImageView(image: UIImage(named: openBoardListFlag ? "upArrow" : "downArrow"))
                cell.contentView.addSubview(rightImageView)
                rightImageView.snp.makeConstraints {
                    make in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-16)
//                    make.height.width.equalTo(screenSize.height*(88/1920))
                    make.height.width.equalTo(15)
                }
                
                // if there's default value for the cell
                if tableView.allowsSelection {
                    cell.addTapGestureRecognizer { [weak tableView]
                        sender in
                        self.textView.resignFirstResponder()
                        //                    print("选板块啊")
                        if self.openBoardListFlag == false {
                            if let forum = self.selectedForum {
                                BBSJarvis.getBoardList(forumID: forum.id) {
                                    dict in
                                    self.openBoardListFlag = true
                                    if let data = dict["data"] as? [String: Any],
                                        let boards = data["boards"] as? [[String: Any]] {
                                        self.boardList = Mapper<BoardModel>().mapArray(JSONArray: boards)
                                        tableView?.reloadSections([1], with: .none)
                                    }
                                }
                            } else {
                                HUD.flash(.label("请先选择讨论区"))
                            }
                        } else {
                            self.openBoardListFlag = false
                            tableView?.reloadSections([1], with: .automatic)
                        }
                    }
                }
                rightImageView.isHidden = !tableView.allowsSelection
                cell.isUserInteractionEnabled = tableView.allowsSelection

                let separator = UIView()
                cell.contentView.addSubview(separator)
                separator.backgroundColor = .gray
                separator.alpha = 0.5
                separator.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.height.equalTo(0.2)
                }
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "normalCell")
                cell.textLabel?.text = boardList[indexPath.row-1].name
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                cell.contentView.addSubview(textField)
                textField.snp.makeConstraints {
                    make in
                    make.centerY.equalTo(cell.contentView)
                    make.right.equalTo(cell.contentView).offset(-16)
                }
                if placeholderTitle != "" {
                    textField.text = placeholderTitle
                } else {
                    textField.placeholder = "帖子的标题"
                }
                textField.textAlignment = .right

                let titleLabel = UILabel(text: "标题")
                titleLabel.font = UIFont.systemFont(ofSize: 17)
                cell.contentView.addSubview(titleLabel)
                titleLabel.snp.makeConstraints {
                    make in
                    make.left.equalTo(cell.contentView).offset(16)
                    make.centerY.equalTo(cell.contentView)
                    make.right.equalTo(textField.snp.left).offset(-8)
                }
                return cell
            } else {
                let cell = UITableViewCell()
                cell.textLabel?.text = "正文:"
                return cell
            }
        case 3:
            let cell = UITableViewCell()
            textView.frame = CGRect(x: 15, y: 5, width: self.view.width - 30, height: 200)
            cell.contentView.addSubview(textView)
            cell.width = self.view.width
            cell.height = textView.height + textView.y
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension AddThreadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.textView.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row != 0 {
            selectedForum = forumList[indexPath.row-1]
        } else if indexPath.section == 1 && indexPath.row != 0 {
            selectedBoard = boardList[indexPath.row-1]
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: 3) {
            return 205
        } else {
            return 44.5
        }
    }
}

extension AddThreadViewController {
    func keyboardWillHide(notification: NSNotification) {
        textView.height = self.view.height
        bar.removeFromSuperview()
        tableView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        textView.frame = CGRect(x: 15, y: 5, width: self.view.width - 30, height: 200)
        tableView.updateConstraintsIfNeeded()
        textView.updateConstraintsIfNeeded()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let endRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let beginRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if(beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y >= 0)){
                self.view.addSubview(bar)
                bar.y = 0
                let barHeight: CGFloat = 40
                let height = view.frame.size.height - endRect.size.height - barHeight
                textView.height = height - 10 // 10: margin
                textView.setNeedsLayout()
                bar.x = 0
                bar.y = height
                bar.width = self.view.width
                bar.height = barHeight
                tableView.snp.remakeConstraints { make in
                    make.top.equalToSuperview()//.offset(-40)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(self.view.height-height-10)
                }
                textView.frame = CGRect(x: 15, y: 5, width: self.view.width - 30, height: 200)

                tableView.updateConstraintsIfNeeded()
                textView.updateConstraintsIfNeeded()
            }
        }
    }
}

extension AddThreadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let size = image.size
            let maxWidth: CGFloat = 200
            var ratio: CGFloat = 1.0
            if size.width > maxWidth {
                ratio = maxWidth/size.width
            }
            let resizedImage = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: size.width*ratio, height: size.height*ratio))
            
            let attachment = ImageTextAttachment()
            attachment.image = resizedImage
            // resizedImage.hash as index
            let attributedString = NSAttributedString(attachment: attachment)
            textStorage.insert(attributedString, at: textView.selectedRange.location)
            textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
            attachments.append(attachment)
            
            BBSJarvis.getImageAttachmentCode(image: image, progressBlock: { progress in
                attachment.progressView.progress = progress.fractionCompleted
                if progress.fractionCompleted >= 1.0 {
                    if attachment.progressView.superview != nil {
                        attachment.progressView.removeFromSuperview()
                    }
                }
            }, failure: { error in
                HUD.flash(.labeledError(title: "上传失败🙄", subtitle: nil))
            }, success: { attachmentCode in
                self.imageMap[resizedImage.hash] = attachmentCode
            })
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddThreadViewController: NSLayoutManagerDelegate {
    
    func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if layoutFinishedFlag {
            let imgAttachments = textStorage.attributedSubstring(from: NSMakeRange(0, textStorage.length)).attachmentRanges.map { $0.attachment }
            let diff = attachments.filter { !imgAttachments.contains($0) }
            for attachment in diff {
                if attachment.progressView.superview != nil {
                    attachment.progressView.removeFromSuperview()
                }
            }
            layoutSubviews()
            if diff.count > 0 { // if some attachments are deleteds
                attachments = imgAttachments
            }
        }
    }
    
    func layoutSubviews() {
        let layoutManager = textView.layoutManager
        
        let attachs = textStorage.attributedSubstring(from: NSMakeRange(0, textStorage.length)).attachmentRanges
        for  (attachment, range) in attachs {
            let glyphRange = layoutManager.glyphRange(forCharacterRange: NSMakeRange(range.location, 1), actualCharacterRange: nil)
            let glyphIndex = glyphRange.location
            guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
                return
            }
            
            let attachmentSize = layoutManager.attachmentSize(forGlyphAt: glyphIndex)
            guard attachmentSize.width > 0.0 && attachmentSize.height > 0.0 else {
                return
            }
            
            let lineFragmentRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
            let glyphLocation = layoutManager.location(forGlyphAt: glyphIndex)
            guard lineFragmentRect.width > 0.0 && lineFragmentRect.height > 0.0 else {
                return
            }
            let attachmentRect = CGRect(origin: CGPoint(x: lineFragmentRect.minX + glyphLocation.x,y: lineFragmentRect.minY + glyphLocation.y - attachmentSize.height), size: attachmentSize)
            let insets = self.textView.textContainerInset
            let convertedRect = attachmentRect.offsetBy(dx: insets.left, dy: insets.top)
            UIView.performWithoutAnimation {
                guard attachment.progressView.progress < 1.0 else {
                    return
                }
                attachment.progressView.frame = convertedRect
                if attachment.progressView.superview == nil {
                    self.textView.addSubview(attachment.progressView)
                }
            }
        }
    }
}

