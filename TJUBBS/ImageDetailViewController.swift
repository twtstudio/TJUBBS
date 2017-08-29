//
//  ImageDetailViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import PKHUD

class ImageDetailViewController: UIViewController {
    var scrollView: UIScrollView! = nil
    var imgView: UIImageView! = nil
    var image: UIImage! = nil
    let saveBtn = UIButton(type: .roundedRect)
    var lastPos: CGPoint = CGPoint()
    var maximumZoomScale: CGFloat = 1.5

    var showSaveBtn: Bool = false {
        didSet {
            if showSaveBtn {
                saveBtn.isHidden = false
                saveBtn.setTitle("保存", for: .normal)
                saveBtn.frame = CGRect(x: UIScreen.main.bounds.width-60, y: UIScreen.main.bounds.height-60, width: 45, height: 25)
                saveBtn.setTitleColor(.white, for: .normal)
                saveBtn.layer.borderColor = UIColor.white.cgColor
                saveBtn.layer.cornerRadius = 3
                saveBtn.layer.borderWidth = 0.8
                saveBtn.backgroundColor = .clear
                saveBtn.alpha = 0.8
                self.view.addSubview(saveBtn)
                saveBtn.addTarget { [weak self] button in
                    if let image = self?.image {
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(image:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
            } else {
                saveBtn.isHidden = true
                saveBtn.removeFromSuperview()
            }
        }
    }
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }
        
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            HUD.flash(.labeledError(title: "保存失败", subtitle: "是不是没有在设置中开启相册访问权限😐"), delay: 1.2)
            return
        }
        HUD.flash(.labeledSuccess(title: "保存成功", subtitle: nil), delay: 1.2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.black

        scrollView.isUserInteractionEnabled = true

        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.delegate = self
        imgView = UIImageView()
        imgView.image = image
        imgView.isUserInteractionEnabled = true
        scrollView.addSubview(imgView)
        imgView.frame = scrollView.frame
        imgView.contentMode = .scaleAspectFit
        self.view.addSubview(scrollView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipeDismiss(recognizer:)))
        imgView.addGestureRecognizer(panGesture)
        
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleClicked(recognizer:)))
        doubleGesture.numberOfTapsRequired = 2
        imgView.addGestureRecognizer(doubleGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(recognizer:)))
        imgView.addGestureRecognizer(longPressGesture)

        
        
        imgView.addTapGestureRecognizer(gestureHandler: { recognizer in
            recognizer.require(toFail: doubleGesture)
        }) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }

    func swipeDismiss(recognizer: UIPanGestureRecognizer) {
        let position = recognizer.translation(in: imgView)
        if recognizer.state == .began {
            lastPos = position
        } else if recognizer.state == .ended {
            if abs(position.y-lastPos.y) > 100 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func longPress(recognizer: UILongPressGestureRecognizer) {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        if let cgImage = self.image.cgImage, let features = detector?.features(in: CIImage(cgImage: cgImage)) {
            for feature in features {
                if let feature = feature as? CIQRCodeFeature, let message = feature.messageString {
                    let ac = UIAlertController(title: "二维码信息", message: message, preferredStyle: .actionSheet)
                    if let url = URL(string: message) {
                        ac.addAction(UIAlertAction(title: "使用 Safari 打开", style: .default) {
                            action in
                            UIApplication.shared.openURL(url)
                        })
                    }
                    ac.addAction(UIAlertAction(title: "复制到剪贴板", style: .default) {
                        action in
                        UIPasteboard.general.string = message
                        HUD.flash(.labeledSuccess(title: "已复制", subtitle: nil), delay: 1.0)
                    })
                    ac.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    present(ac, animated: true, completion: nil)
                    break
                }
            }
        }
        
    }
    
    func doubleClicked(recognizer: UITapGestureRecognizer) {
        recognizer.numberOfTapsRequired = 2
        if self.scrollView.zoomScale > CGFloat(1.0) {
            self.scrollView.setZoomScale(1.0, animated: true)
        } else {
            self.scrollView.setZoomScale(1.5, animated: true)
        }

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
}
