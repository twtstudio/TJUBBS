//
//  HomePageHeaderView.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/6/7.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class HomePageHeaderView: UIView {
    let container = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15 - 10))
    
    let announceLabel = UILabel(text: "公告", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)
    let activityLabel = UILabel(text: "活动", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)
    let eliteLabel = UILabel(text: "十大", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)
    let rankLabel = UILabel(text: "排行", color: UIColor(white: 0.15, alpha: 1), fontSize: 12, weight: UIFontWeightLight)

    let announceButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let activityButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let eliteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let rankButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))

    let baseWidth = UIScreen.main.bounds.width / 8
    let buttonSize = 35
    let bottomHeight = -25
    let topHeight = 5

//    var headScrollView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
//    var scrollerPicView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
//    var pageControl: UIPageControl?

//    static var loadingImage1 = UIImage(named: "轮播1")
//    static var loadingPic1 = UIImageView(image: loadingImage1)
//    static var loadingImage3 = UIImage(named: "轮播3")
//    static var loadingPic3 = UIImageView(image: loadingImage3)
//    static var loadingImage2 = UIImage(named: "轮播2")
//    static var loadingPic2 = UIImageView(image: loadingImage2)
//    static var pic = [loadingPic1, loadingPic2, loadingPic3]

    override init(frame: CGRect) {
        super.init(frame: frame)
        container.backgroundColor = UIColor.white
        self.addSubview(container)

        container.addSubview(announceButton)
        container.addSubview(activityButton)
        container.addSubview(eliteButton)
        container.addSubview(rankButton)
        container.addSubview(announceLabel)
        container.addSubview(activityLabel)
        container.addSubview(eliteLabel)
        container.addSubview(rankLabel)
        self.backgroundColor = UIColor.clear

//        creatScrollView()
//        container.addSubview(headScrollView)
//        container.addSubview(scrollerPicView)
//        container.addSubview(pageControl!)

//        for i in 0..<3 {
//            self.scrollerPicView.addSubview(HomePageHeaderView.pic[i])
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let annonceBtnImage = UIImage(named: "公告")
        announceButton.setBackgroundImage(annonceBtnImage, for: .normal)
        announceButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth)
            make.bottom.equalTo(container).offset(bottomHeight)
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        let activityBtnImage = UIImage(named: "活动")
        activityButton.setBackgroundImage(activityBtnImage, for: .normal)
        activityButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth * 3)
            make.bottom.equalTo(container).offset(bottomHeight)
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        let eliteBtnImage = UIImage(named: "十大")
        eliteButton.setBackgroundImage(eliteBtnImage, for: .normal)
        eliteButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth * 5)
            make.bottom.equalTo(container).offset(bottomHeight)
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        let rankBtnImage = UIImage(named: "排行")
        rankButton.setBackgroundImage(rankBtnImage, for: .normal)
        rankButton.snp.makeConstraints { make in
            make.centerX.equalTo(baseWidth * 7)
            make.bottom.equalTo(container).offset(bottomHeight)
            make.height.equalTo(buttonSize)
            make.width.equalTo(buttonSize)
        }

        rankLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rankButton)
            make.top.equalTo(rankButton.snp.bottom).offset(topHeight)
        }

        announceLabel.snp.makeConstraints { make in
            make.centerX.equalTo(announceButton)
            make.top.equalTo(announceButton.snp.bottom).offset(topHeight)
        }

        activityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(activityButton)
            make.top.equalTo(activityButton.snp.bottom).offset(topHeight)
        }

        eliteLabel.snp.makeConstraints { make in
            make.centerX.equalTo(eliteButton)
            make.top.equalTo(eliteButton.snp.bottom).offset(topHeight)
        }

//        self.headScrollView.snp.makeConstraints { make in
//            make.top.equalTo(latestActivityLabel.snp.bottom).offset(10)
//
//            make.bottom.equalTo(announceButton.snp.top).offset(-10)
//            make.width.equalTo(UIScreen.main.bounds.width)
//        }
//
//        self.scrollerPicView.snp.makeConstraints { make in
//            make.top.equalTo(headScrollView.snp.top)
//            make.bottom.equalTo(headScrollView.snp.bottom)
//            make.width.equalTo(UIScreen.main.bounds.width)
//            make.centerX.equalTo(headScrollView.snp.centerX)
//        }
//
//        self.pageControl?.snp.makeConstraints { make in
//            make.bottom.equalTo(headScrollView.snp.bottom)
//            make.height.equalTo(30)
//            make.width.equalTo(140)
//            make.centerX.equalTo(scrollerPicView.snp.centerX)
//        }
//
//        for i in 0..<3 {
//            HomePageHeaderView.pic[i].snp.makeConstraints { make in
//                make.top.equalTo(searchButton.snp.bottom).offset(10)
//                make.bottom.equalTo(announceButton.snp.top).offset(-10)
//                make.width.equalTo(UIScreen.main.bounds.width)
//
//                make.left.equalToSuperview().offset(i * Int(UIScreen.main.bounds.width))
//            }
//        }

//        HomePageHeaderView.pic[0].snp.makeConstraints() { make in
//            make.top.equalTo(searchButton.snp.bottom).offset(10)
//            make.bottom.equalTo(announceButton.snp.top).offset(-10)
//            make.width.equalTo(UIScreen.main.bounds.width)
//            make.left.equalToSuperview().offset(0 * Int(UIScreen.main.bounds.width))
//        }
//
//        HomePageHeaderView.pic[1].snp.makeConstraints() { make in
//            make.top.equalTo(searchButton.snp.bottom).offset(10)
//            make.bottom.equalTo(announceButton.snp.top).offset(-10)
//            make.width.equalTo(UIScreen.main.bounds.width)
//            make.left.equalToSuperview().offset(1 * Int(UIScreen.main.bounds.width))
//        }
//
//        HomePageHeaderView.pic[2].snp.makeConstraints() { make in
//            make.top.equalTo(searchButton.snp.bottom).offset(10)
//            make.bottom.equalTo(announceButton.snp.top).offset(-10)
//            make.width.equalTo(UIScreen.main.bounds.width)
//            make.left.equalToSuperview().offset(2 * Int(UIScreen.main.bounds.width))
//        }

    }

//    func creatScrollView() {
//        self.headScrollView.addSubview(scrollerPicView)
//        self.headScrollView.backgroundColor = UIColor.clear
//
//        let height = self.scrollerPicView.frame.size.height
//        let width = self.scrollerPicView.frame.size.width
//
//        self.scrollerPicView.contentSize = CGSize(width: width * 3, height: height)
//        self.scrollerPicView.isPagingEnabled = true
//        self.scrollerPicView.showsVerticalScrollIndicator = false
//        self.scrollerPicView.showsHorizontalScrollIndicator = false
//
//        self.scrollerPicView.delegate = self
//        creatPageControl()
//    }

//    func creatPageControl() {
//        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        self.pageControl!.numberOfPages = 3
//        self.pageControl!.currentPage = 0
//
//        self.pageControl!.currentPageIndicatorTintColor = UIColor.darkGray
//        self.pageControl!.pageIndicatorTintColor = UIColor.white
//
//        self.headScrollView.addSubview(self.pageControl!)
//    }
}

extension HomePageHeaderView: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let wid = scrollerPicView.frame.size.width
//        let pageNumber: CGFloat = scrollerPicView.contentOffset.x / wid
//        self.pageControl?.currentPage = (Int)(pageNumber)
//    }
}

extension UIImage {
    
    //将图片缩放成指定尺寸（多余部分自动删除）
    func scaled(to newSize: CGSize) -> UIImage {
        //计算比例
        let aspectWidth  = newSize.width/size.width
        let aspectHeight = newSize.height/size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        //图片绘制区域
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
