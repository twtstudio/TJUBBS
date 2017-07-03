//
//  EditDetailViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/6/29.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Marklight
import PKHUD


class EditDetailViewController: UIViewController {
    let textView = UITextView()
    var placeholder = ""
    let textStorage = MarklightTextStorage()
    let bar = UIToolbar()
    var isAnonymous = false
    var canAnonymous = false
    var imageMap: [Int : Int] = [:]
    var doneBlock: ((String) -> ())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func loadPlaceholder() {
        self.view.backgroundColor = textView.backgroundColor
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.frame = CGRect(x: 15, y: 10, width: self.view.width - 30, height: self.view.height-10)
        self.view.addSubview(textView)
        
        // markdown parser
        textStorage.addLayoutManager(textView.layoutManager)
        textStorage.appendString(placeholder)
        
        // set the cursor
        textView.selectedRange = NSMakeRange(placeholder.characters.count, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        loadPlaceholder()
        
        let doneItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(self.doneButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = doneItem
        
        let imageButton = UIButton(imageName: "icn_upload")
        imageButton.tintColor = .gray
        imageButton.addTarget { btn in
            // TODO: 拍照
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
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
        
        let boldButton = UIButton(title: "B")
        let boldItem = UIBarButtonItem(customView: boldButton)
        
        let italicButton = UIButton(title: "I")
        let italicItem = UIBarButtonItem(customView: italicButton)
        
        let headButton = UIButton(title: "#")
        let headItem = UIBarButtonItem(customView: headButton)
        
        let quoteButton = UIButton(title: "\"")
        let quoteItem = UIBarButtonItem(customView: quoteButton)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bar.items = [imageItem, flexibleSpace, boldItem, italicItem, headItem, quoteItem]
        for item in bar.items! {
            if let button = item.customView as? UIButton {
                item.width = 40
                button.width = 40
                button.height = 35
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                button.addTarget(self, action: #selector(self.barButtonTapped(sender:)), for: .touchUpInside)
            }
        }
        
        if canAnonymous {
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
            bar.items?.insert(anonymousItem, at: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.textView.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    func doneButtonTapped(sender: UIBarButtonItem) {
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
                let string = resultString.string
                self.doneBlock?(string)
            } else {
                HUD.flash(.label("不可以发布空白贴哦👀"), delay: 1.0)
            }
        }
    }
    
    func barButtonTapped(sender: UIButton) {
//        if let title = (sender.customView as? UIButton)?.currentTitle {
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
}

extension EditDetailViewController {
    func keyboardWillHide(notification: NSNotification) {
        textView.height = self.view.height
        bar.removeFromSuperview()
        textView.setNeedsLayout()
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
            }
        }
    }
}

extension EditDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let size = image.size
            let maxWidth: CGFloat = 200
            var ratio: CGFloat = 1.0
            if size.width > maxWidth {
                ratio = maxWidth/size.width
            }
            let resizedImage = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: size.width*ratio, height: size.height*ratio))
            
            let attachment = NSTextAttachment()
            attachment.image = resizedImage
            // resizedImage.hash as index
//            imageMap[resizedImage.hash] = resizedImage.hash
            let attributedString = NSAttributedString(attachment: attachment)
            textStorage.insert(attributedString, at: textView.selectedRange.location)

            BBSJarvis.getImageAttachmentCode(image: image, failure: { error in
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
