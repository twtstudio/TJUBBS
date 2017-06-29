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
    var placeholder: NSAttributedString?
    let textStorage = MarklightTextStorage()
    let bar = UIToolbar()
    var isAnonymous = false
    var canAnonymous = false
    weak var delegate: UIViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textStorage.addLayoutManager(textView.layoutManager)
        textStorage.fontTextStyle = UIFontTextStyle.headline.rawValue
        textView.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(textView)
        textView.frame = CGRect(x: 15, y: 10, width: self.view.width - 30, height: self.view.height-10)

        let imageItem = UIBarButtonItem(image: UIImage(named: "icn_upload"), style: .plain, target: self, action: #selector(self.barButtonTapped(sender:)))
        let boldItem = UIBarButtonItem(title: "B", style: .plain, target: self, action: #selector(self.barButtonTapped(sender:)))
        let italicItem = UIBarButtonItem(title: "I", style: .plain, target: self, action: #selector(self.barButtonTapped(sender:)))
        let headItem = UIBarButtonItem(title: "#", style: .plain, target: self, action: #selector(self.barButtonTapped(sender:)))
        let quoteItem = UIBarButtonItem(title: "\"", style: .plain, target: self, action: #selector(self.barButtonTapped(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [imageItem, flexibleSpace, boldItem, italicItem, headItem, quoteItem]
        for item in bar.items! {
            if item.title != nil {
                item.width = 40
            }
        }
        
        canAnonymous = true
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
            anonymousSwitch.snp.makeConstraints { make in
                make.left.equalTo(anonymousLabel.snp.right)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.centerY.equalTo(anonymousLabel)
                make.right.equalToSuperview()
            }
            anonymousView.height = max(anonymousLabel.height, anonymousSwitch.height)
            anonymousView.width = anonymousLabel.width + anonymousSwitch.width
            let anonymousItem = UIBarButtonItem(customView: anonymousView)
            anonymousItem.width = anonymousView.width
            anonymousSwitch.addTarget(self, action: #selector(self.anonymousStateOnChange(sender:)), for: .valueChanged)
            bar.items?.insert(anonymousItem, at: 1)
        }
//        
//        for item in bar.items! {
//            if item.title != nil {
//                item.width = 40
//            }
//        }
//        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func barButtonTapped(sender: UIBarButtonItem) {
        if let title = sender.title {
            switch title {
            case "B":
                textStorage.appendString("****")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+2, 0)
            case "I":
                textStorage.appendString("**")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
            case "#":
//                let aString = NSAttributedString(string: "#")
//                textStorage.insert(aString, at: textView.selectedRange.location)
                textStorage.appendString("#")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
            case "\"":
                textStorage.appendString(">")
                textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
            default:
                break
            }
            print(sender)
        }
        if sender.image != nil {
            // TODO: 拍照
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .savedPhotosAlbum
                self.present(imagePicker, animated: true) {
                    
                }
            } else {
                HUD.flash(.label("相册不可用🤒请在设置中打开 BBS 的相册权限"), delay: 2.0)
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
            if(beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y > 0)){
                self.view.addSubview(bar)
                let barHeight: CGFloat = 40
                let height = view.frame.size.height - endRect.size.height - barHeight
                textView.height = height
                textView.setNeedsLayout()
                bar.x = 0
                bar.y = height
                bar.width = self.view.width
                bar.height = barHeight
//                bar.snp.remakeConstraints { make in
//                    make.left.equalToSuperview()
//                    make.height.equalTo(40)
//                    make.right.equalToSuperview()
//                    make.top.equalTo(textView.snp.bottom)
//                }
            }
        }
    }
}

extension EditDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let smallerImage = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: 80, height: 80))
            
            let attachment = NSTextAttachment()
            attachment.image = smallerImage
            let attributedString = NSAttributedString(attachment: attachment)
            textStorage.append(attributedString)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
