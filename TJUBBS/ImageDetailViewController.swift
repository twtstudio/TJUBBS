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
        scrollView.isUserInteractionEnabled
        scrollView.maximumZoomScale = 1.5
        scrollView.delegate = self
        imgView = UIImageView(frame: self.view.bounds)
        imgView.image = image
        scrollView.addSubview(imgView)
        self.view.addSubview(scrollView)
        imgView.addTapGestureRecognizer { _ in //[weak self] _ in
            print("touched")
            self.dismiss(animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ImageDetailViewController: UIScrollViewDelegate {
    
}
