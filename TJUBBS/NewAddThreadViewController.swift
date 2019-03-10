//
//  NewAddThreadViewController.swift
//  TJUBBS
//
//  Created by 张毓丹 on 2019/2/2.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class NewAddThreadViewController: UIViewController {

    
    var titleView = UIView()
    var contentView = UIView()
    var selectView = UIView()
    var selectAlertView : UIView?
    
    var titleLabel = UILabel()
    var contentLabel = UILabel()
    
    var titleTextView = UITextView()
    var contentTextView = UITextView()
    
    var UIImgButton = UIButton()
    var UIemojyButton = UIButton()
    
    
    
    let textPlaceHolder = "不少于4个字"
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let leftCloseBtn = UIBarButtonItem(barButtonSystemItem: .stop,target: self, action: nil)
        leftCloseBtn.tintColor = .black
    
        let leftSentBtn = UIBarButtonItem(title: "发帖", style: .done, target: self, action: nil)
        let leftItems: [UIBarButtonItem] = [leftCloseBtn, leftSentBtn]
    
        let rightImg = UIImage(named: "发布")
    
        let rightItem = UIBarButtonItem(image: rightImg, style: .plain, target: self, action: nil)
        
        rightItem.tintColor = .BBSBlue
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.setLeftBarButtonItems(leftItems, animated: true)
        self.view.backgroundColor = UIColor(red: 200, green: 238, blue: 238, alpha: 0.0)
        
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let anonySwitch = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width-110, y: 280, width: 30, height: 18))
        let anonyLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 280, width: 40, height: 30))
        //let anonySwitch = UISwitch()
        
        let titleImg = UIImage(named: "标题 (1)")
        let contentImg = UIImage(named: "文章 (1)")
        let imgButtonImg = UIImage(named: "图片")
        let imgButtonImgView = UIImageView(image: imgButtonImg)
        let emojyButtonImg = UIImage(named:"表情")
        let emojyButtonImgView = UIImageView(image: emojyButtonImg)
        
        let titleImgView = UIImageView(image: titleImg)
        let contentImgView = UIImageView(image: contentImg)
        
        
        titleView.addSubview(titleTextView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleImgView)
        contentView.addSubview(contentTextView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentImgView)
        contentTextView.addSubview(anonySwitch)
        contentTextView.addSubview(anonyLabel)
        contentTextView.addSubview(imgButtonImgView)
        contentTextView.addSubview(emojyButtonImgView)
        
        self.view.addSubview(contentView)
        self.view.addSubview(titleView)
        self.view.addSubview(selectView)
        //        let titleViewY = self.navigationController?.navigationBar.frame.height ?? 44 + UIApplication.shared.statusBarFrame.height + 10
        
        anonySwitch.setOn(true, animated: true)
        anonySwitch.onTintColor = .lightGray
        anonySwitch.tintColor = .gray
        anonySwitch.thumbTintColor = .white
        anonySwitch.addTarget(self, action: #selector(switchClick), for: .valueChanged)
        anonyLabel.text = "匿名"
        anonyLabel.tintColor = .black
        anonyLabel.font = UIFont.systemFont(ofSize: 16)
        
      
     
          emojyButtonImgView.isUserInteractionEnabled = true
        let emojyClick = UITapGestureRecognizer(target: self, action: #selector(emojyButtonImgViewTapped))
        
        emojyButtonImgView.addGestureRecognizer(emojyClick)
        imgButtonImgView.isUserInteractionEnabled = true
        let imgClick = UITapGestureRecognizer(target: self, action: #selector(imgButtonImgViewTapped))
        imgButtonImgView.addGestureRecognizer(imgClick)
        
        
        
        titleView.frame = CGRect(x: 0, y: 98, width: UIScreen.main.bounds.width
            , height:100)
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.centerY.equalTo(titleImgView.snp.centerY)
            make.left.equalTo(titleImgView.snp.right).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
        titleLabel.text = "输入标题..."
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleImgView.snp.makeConstraints{(make)->Void in
            make.centerX.equalTo(20)
            make.centerY.equalTo(15)
            make.width.equalTo(25)
            make.height.equalTo(25)
            
        }
        titleImgView.tintColor = .black
        self.view.backgroundColor = .clear
        //titleView.backgroundColor = .blue
        titleView.autoresizesSubviews = true
        titleTextView.snp.makeConstraints{(make)-> Void in
            make.top.equalTo(titleView.snp.top).offset(36)
            make.bottom.equalTo(titleView.snp.bottom)
            make.width.equalTo(titleView)
            make.height.equalTo(40)
        }
       // titleTextView.backgroundColor = .green
        titleTextView.text = textPlaceHolder
        titleTextView.font = UIFont.systemFont(ofSize: 16)
        titleTextView.delegate = self
        
        
        contentView.snp.makeConstraints{(make)-> Void  in
            make.centerX.equalTo(titleView.snp.centerX)
            make.top.equalTo(titleView.snp.bottom).offset(1)
            make.width.equalTo(titleView.snp.width)
            make.height.equalTo(400)
        }
        //contentView.backgroundColor = .red
        contentLabel.snp.makeConstraints {(make) -> Void in
            make.centerY.equalTo(contentImgView.snp.centerY)
            make.left.equalTo(contentImgView.snp.right).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
        contentLabel.text = "输入内容..."
        contentLabel.font = UIFont.systemFont(ofSize: 20)
        contentLabel.textColor = .black
        contentImgView.snp.makeConstraints{(make)->Void in
            make.centerX.equalTo(20)
            make.centerY.equalTo(15)
            make.width.equalTo(25)
            make.height.equalTo(25)
            
        }
        contentImgView.tintColor = .black
        contentTextView.snp.makeConstraints{(make) -> Void in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(30)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalTo(contentView.snp.width)
        }
       // contentTextView.backgroundColor = .yellow
        contentTextView.text = textPlaceHolder
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.delegate = self
        selectView.snp.makeConstraints{(make) -> Void in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.bottom).offset(10)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(65)
        }
        //selectView.backgroundColor = .lightGray
        
        imgButtonImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.left).offset(80)
            make.centerY.equalTo(contentView.snp.bottom).offset(-40)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        emojyButtonImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.left).offset(40)
            make.centerY.equalTo(contentView.snp.bottom).offset(-40)
            make.width.equalTo(28)
            make.height.equalTo(28)
            
        }
      
    
    }
  
    func switchClick(switch: UISwitch){
        
        
    }
    
    func emojyButtonImgViewTapped(){
        print("emojyButtonImgViewTapped")
    }
    func imgButtonImgViewTapped(){
        
    }

}
extension NewAddThreadViewController: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView){
        if((textView.text) != nil){
            textView.text = "不少于4个字"
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.textColor = .gray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if(textView.text == "不少于4个字"){
            textView.text = ""
            textView.textColor = .black
        }
    }
}



