//
//  AnimatedRefreshingHeader.swift
//  TJUBBS
//
//  Created by Halcao on 2018/11/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import MJRefresh

class AnimatedRefreshingHeader: MJRefreshGifHeader {
    convenience init(target: Any!, action: Selector!, imageName: String = "鹿鹿") {
        self.init(refreshingTarget: target, refreshingAction: action)

        var refreshingImages = [UIImage]()
        for i in 1...6 {
            let image = UIImage(named: "\(imageName)\(i)")?.kf.resize(to: CGSize(width: 60, height: 60))
             refreshingImages.append(image!)
        }
        self.setImages(refreshingImages, duration: 0.2, for: .pulling)
        self.stateLabel.isHidden = true
        self.lastUpdatedTimeLabel.isHidden = true
        self.setImages(refreshingImages, for: .pulling)
    }
}
