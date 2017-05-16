//
//  ImageDetailViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    var scrollView: UIScrollView! = nil
    var imgView: UIImageView! = nil
    var image: UIImage! = nil
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
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
