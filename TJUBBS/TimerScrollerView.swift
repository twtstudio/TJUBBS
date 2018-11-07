//
//  TimerScrollerView.swift
//  TJUBBS
//
//  Created by 侯钦瀚 on 2018/7/17.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

protocol TimerScrollerViewDelegate {
    func scrollToIndexOfPage(index: Int)
    func tapActionIndexOfPage(index: Int)
}

class TimerScrollerView: UIView, UIScrollViewDelegate{
    var count: Int = 0
    var timer: Timer!
    var timerDelegate: TimerScrollerViewDelegate?
    var scrollerView: UIScrollView?
    var pageCT: UIPageControl?
    
    func configScrollView(picArray: [UIImageView], contentOffsetIndex: Int) {
        count = picArray.count
        self.clipsToBounds = false
        self.backgroundColor = UIColor.white
        scrollerView = UIScrollView(frame: self.bounds)
        scrollerView!.delegate = self
        scrollerView!.contentSize = CGSize(width: CGFloat(picArray.count + 2) * self.frame.size.width, height: self.frame.size.height)
        scrollerView!.isPagingEnabled = true
        scrollerView!.showsHorizontalScrollIndicator = false
        scrollerView!.showsVerticalScrollIndicator = false
        self.addSubview(scrollerView!)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector(("tapAction:")))
        scrollerView?.addGestureRecognizer(tap)
        
        //调用函数初始化轮播图
        createImageViews(picArray: picArray, contentOffsetIndex: contentOffsetIndex)
        
        configPageControll(currentPage: contentOffsetIndex)
        
        timerBegin()
    }
    
    func createImageViews(picArray: [UIImageView], contentOffsetIndex: Int) {
        for i in 0 ..< picArray.count + 2 {
            scrollerView!.addSubview(picArray[i])
        }
        
        scrollerView!.contentOffset = CGPoint(x: CGFloat(contentOffsetIndex + 1) * self.frame.size.width, y: 0)
        
    }
    
    func configPageControll(currentPage: Int) {
        pageCT = UIPageControl(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        pageCT!.snp.makeConstraints() { make in
            make.centerX.equalTo(self.scrollerView!.snp.centerX)
            make.height.equalTo(self.scrollerView!.snp.height)
            make.width.equalTo(self.scrollerView!.snp.width)
        }
        pageCT!.pageIndicatorTintColor = UIColor.lightGray
        pageCT!.currentPageIndicatorTintColor = UIColor.white
        pageCT!.numberOfPages = count
        pageCT!.currentPage = currentPage
        self.addSubview(pageCT!)
    }
    
    func timerBegin() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: Selector(("timerRun:")), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    func timerSuspend() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func timerRun(runTimer: Timer) {
        let offsetX = scrollerView!.contentOffset.x
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollerView!.contentOffset = CGPoint(x: offsetX + self.frame.size.width, y: 0)
        }) { (boolValue: Bool) -> Void in
//            self.resetContentOffset()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timerSuspend()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timerBegin()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetContentOffset()
    }
    
    func resetContentOffset() {
        if scrollerView!.contentOffset.x < self.frame.size.width {
            scrollerView!.contentOffset = CGPoint(x: self.frame.size.width * CGFloat(count), y: 0)
        }
        
        if scrollerView!.contentOffset.x > self.frame.size.width * CGFloat(count) {
            scrollerView!.contentOffset = CGPoint(x: self.frame.size.width, y: 0)
        }
        
        let vc = self.timerDelegate as! UIViewController
        if vc.responds(to: Selector(("scrollToIndexOfPage:"))) {
            let index = Int((scrollerView!.contentOffset.x - self.frame.size.width) / self.frame.size.width)
            pageCT?.currentPage = index
            timerDelegate?.scrollToIndexOfPage(index: index)
        }
    }
    
    func tapAction(tap: UITapGestureRecognizer) {
        let vc = self.timerDelegate as! UIViewController
        if vc.responds(to: Selector(("scrollToIndexOfPage:"))) {
            let index = Int((scrollerView!.contentOffset.x - self.frame.size.width) / self.frame.size.width)
            timerDelegate?.tapActionIndexOfPage(index: index)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        for sub in self.subviews {
            if sub is UIButton {
                let button = sub as! UIButton
                let buttonPoint = button.convert(point, from: self)
                if button.point(inside: buttonPoint, with: event) {
                    return button
                }
            }
        }
        return result
    }
}
