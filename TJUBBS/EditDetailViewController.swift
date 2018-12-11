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
import TOCropViewController

class EditDetailViewController: UIViewController {
    let textView = UITextView()
    var placeholder = ""
    let textStorage = MarklightTextStorage()
    let bar = UIToolbar()
    var isAnonymous = false
    var canAnonymous = false
    var imageMap: [Int: Int] = [:]
    var doneBlock: ((String) -> Void)?
    var attachments: [ImageTextAttachment] = []
    var imagePicker: UIImagePickerController!

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
        textView.layoutManager.delegate = self
        textStorage.addLayoutManager(textView.layoutManager)
        let attributedPlaceHolder = NSAttributedString(string: placeholder)
        textView.attributedText = attributedPlaceHolder
//        textStorage.appendString(placeholder)
        textStorage.append(attributedPlaceHolder)

        // set the cursor
        textView.selectedRange = NSRange(location: placeholder.count, length: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        loadPlaceholder()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        let cancelItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(self.cancel(sender:)))
        self.navigationItem.leftBarButtonItem = cancelItem
        let doneItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(self.doneButtonTapped(sender:)))
        self.navigationItem.rightBarButtonItem = doneItem

        let imageButton = UIButton(imageName: "icn_upload")
        imageButton.tintColor = .gray
        imageButton.addTarget { _ in
            // TODO: 拍照
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker = UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
//                imagePicker.cameraOverlayView?.transform = CGAffineTransform(scaleX: 1, y: self.view.height/self.view.width)
                self.present(self.imagePicker, animated: true) {

                }
            } else {
                HUD.flash(.label("相册不可用🤒请在设置中打开 BBS 的相册权限"), delay: 2.0)
            }
        }
        let imageItem = UIBarButtonItem(customView: imageButton)

        let atButton = UIButton(title: "@")
        let atItem = UIBarButtonItem(customView: atButton)

        let boldButton = UIButton(title: "B")
        let boldItem = UIBarButtonItem(customView: boldButton)

        let italicButton = UIButton(title: "I")
        let italicItem = UIBarButtonItem(customView: italicButton)

        let headButton = UIButton(title: "#")
        let headItem = UIBarButtonItem(customView: headButton)

        let quoteButton = UIButton(title: "\"")
        let quoteItem = UIBarButtonItem(customView: quoteButton)

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        bar.items = [imageItem, flexibleSpace, atItem, boldItem, italicItem, headItem, quoteItem]
        for item in bar.items! {
            if let button = item.customView as? UIButton {
                item.width = 35
                button.width = 35
                button.height = 35
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                button.addTarget(self, action: #selector(self.barButtonTapped(sender:)), for: .touchUpInside)
            }
        }

        if canAnonymous {
            if UIScreen.main.bounds.width < 321 {
                for i in (3...6).reversed() {
                    let negSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                    negSpacer.width = -16
                    bar.items?.insert(negSpacer, at: i)
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
            bar.items?.insert(anonymousItem, at: 1)
        }
    }

    func cancel(sender: UIBarButtonItem) {
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func doneButtonTapped(sender: UIBarButtonItem) {
        let fullRange = NSRange(location: 0, length: textStorage.length)
        let resultString = NSMutableAttributedString(attributedString: textStorage.attributedSubstring(from: fullRange))
        var isUploading = false
        textStorage.enumerateAttributes(in: fullRange, options: .reverse, using: { attributes, range, _ in
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
//                let hyperlinkedString = resultString.string.replacingOccurrences(of: "^((https?|http?):\\/\\/)?([a-z]([a-z0-9\\-]*[\\.。])+([a-z]{2}|aero|arpa|biz|com|coop|edu|gov|info|int|jobs|mil|museum|name|nato|net|org|pro|travel)|(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))(\\/[a-z0-9_\\-\\.~]+)*(\\/([a-z0-9_\\-\\.]*)(\\?[a-z0-9+_\\-\\.%=&]*)?)?(#[a-z][a-z0-9_]*)?$", with: "[$0]($0)", options: .regularExpression, range: nil)

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
                textView.selectedRange = NSRange(location: textView.selectedRange.location+2, length: 0)
            case "I":
//                textStorage.appendString("**")
                textStorage.replaceCharacters(in: textView.selectedRange, with: "**")
                textView.selectedRange = NSRange(location: textView.selectedRange.location+1, length: 0)
            case "#":
                textStorage.replaceCharacters(in: textView.selectedRange, with: "#")
//                textStorage.appendString("#")
                textView.selectedRange = NSRange(location: textView.selectedRange.location+1, length: 0)
            case "\"":
                textStorage.replaceCharacters(in: textView.selectedRange, with: ">")
//                textStorage.appendString(">")
                textView.selectedRange = NSRange(location: textView.selectedRange.location+1, length: 0)
            case "@":
                let userSearchVC = UserSearchViewController()
                userSearchVC.doneBlock = { uid, username in
                    self.textStorage.replaceCharacters(in: self.textView.selectedRange, with: "[@\(username)](/user/\(uid))")
                    let offset = 2 + username.count + 8 + uid.description.count + 1
                    self.textView.selectedRange = NSRange(location: self.textView.selectedRange.location+offset, length: 0)
                    self.textView.becomeFirstResponder()
                }
                self.textView.resignFirstResponder()
                self.navigationController?.pushViewController(userSearchVC, animated: true)
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
//        textView.setNeedsLayout()
    }

    func keyboardWillShow(notification: NSNotification) {
        if let endRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let beginRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if(beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y >= 0)) {
                self.view.addSubview(bar)
                let barHeight: CGFloat = 40
                let height = view.frame.size.height - endRect.size.height - barHeight
                textView.height = height - 10 // 10: margin
//                textView.setNeedsLayout()
                bar.y = 600
                UIView.performWithoutAnimation {
                    self.bar.x = 0
                    self.bar.y = height
                    self.bar.width = self.view.width
                    self.bar.height = barHeight
                }
            }
        }
    }
}

extension EditDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cropVC = TOCropViewController(image: image)
            cropVC.delegate = self
            picker.present(cropVC, animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

// overlay on images which are uploading
extension EditDetailViewController: NSLayoutManagerDelegate {

    func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if layoutFinishedFlag {
            let imgAttachments = textStorage.attributedSubstring(from: NSRange(location: 0, length: textStorage.length)).attachmentRanges.map { $0.attachment }
            let diff = attachments.filter { !imgAttachments.contains($0) }
            for attachment in diff {
                // if some attachments are deleted, remove them
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

        let attachs = textStorage.attributedSubstring(from: NSRange(location: 0, length: textStorage.length)).attachmentRanges
        for  (attachment, range) in attachs {
            guard attachment.progressView.progress < 1.0 else {
                // if on the screen, remove it
                if attachment.progressView.superview != nil {
                    attachment.progressView.removeFromSuperview()
                }
                return
            }
            // calculate the frame
            let glyphRange = layoutManager.glyphRange(forCharacterRange: NSRange(location: range.location, length: 1), actualCharacterRange: nil)
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
            let attachmentRect = CGRect(origin: CGPoint(x: lineFragmentRect.minX + glyphLocation.x, y: lineFragmentRect.minY + glyphLocation.y - attachmentSize.height), size: attachmentSize)
            let insets = self.textView.textContainerInset
            let convertedRect = attachmentRect.offsetBy(dx: insets.left, dy: insets.top)

            // change view's postion by using the frame calculated above
            UIView.performWithoutAnimation {
                attachment.progressView.frame = convertedRect
                if attachment.progressView.superview == nil {
                    self.textView.addSubview(attachment.progressView)
                }
            }

        }
    }
}

extension EditDetailViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        let size = cropRect
        let maxWidth: CGFloat = 200
        var ratio: CGFloat = 1.0
        if size.width > maxWidth {
            ratio = maxWidth/size.width
        }
        cropViewController.dismiss(animated: true, completion: { self.imagePicker.dismiss(animated: false, completion: nil) })
        let resizedImage = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: size.width*ratio, height: size.height*ratio))

        let attachment = ImageTextAttachment()
        attachment.image = resizedImage
        // resizedImage.hash as index
        let attributedString = NSAttributedString(attachment: attachment)
        textStorage.insert(attributedString, at: textView.selectedRange.location)
        textView.selectedRange = NSRange(location: textView.selectedRange.location+1, length: 0)
        attachments.append(attachment)
        BBSJarvis.getImageAttachmentCode(image: image, progressBlock: { progress in
            attachment.progressView.progress = progress.fractionCompleted
            if progress.fractionCompleted >= 1.0 {
                if attachment.progressView.superview != nil {
                    attachment.progressView.removeFromSuperview()
                }
            }
        }, failure: { _ in
            HUD.flash(.labeledError(title: "上传失败🙄", subtitle: nil))
        }, success: { attachmentCode in
            self.imageMap[resizedImage.hash] = attachmentCode
        })

    }

}
