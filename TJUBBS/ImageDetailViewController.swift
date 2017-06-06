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
    var showSaveBtn: Bool = false {
        didSet {
            if showSaveBtn {
                saveBtn.isHidden = false
                saveBtn.setTitle("保存", for: .normal)
                saveBtn.frame = CGRect(x: UIScreen.main.bounds.width-60, y: UIScreen.main.bounds.height-60, width: 45, height: 25)
//                saveBtn.sizeToFit()
//                saveBtn.buttonType = .roundedRect
//                saveBtn.titleLabel?.textColor = .white
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

        scrollView.maximumZoomScale = 1.5
        scrollView.delegate = self
        imgView = UIImageView()
        imgView.image = image
        imgView.isUserInteractionEnabled = true
        scrollView.addSubview(imgView)
        imgView.frame = scrollView.frame
        imgView.contentMode = .scaleAspectFit
//        imgView.snp.makeConstraints { make in
//            make.center.equalTo(scrollView)
//            make.width.height.equalTo(self.view.bounds.size.width)
//        }
        self.view.addSubview(scrollView)
//        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDismiss(recognizer:)))
//        swipeUpGesture.direction = .up
//        
//        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDismiss(recognizer:)))
//        swipeDownGesture.direction = .down
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipeDismiss(recognizer:)))
        imgView.addGestureRecognizer(panGesture)
        
//        imgView.addGestureRecognizer(swipeUpGesture)
//        imgView.addGestureRecognizer(swipeDownGesture)
        
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleClicked(recognizer:)))
        doubleGesture.numberOfTapsRequired = 2
        imgView.addGestureRecognizer(doubleGesture)
        
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
//        if recognizer.
//        if recognizer.direction == .up || recognizer.direction == .down {
//            self.dismiss(animated: true, completion: nil)
//        }
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
