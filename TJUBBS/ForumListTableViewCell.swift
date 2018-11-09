//
//  ForumTableViewCell.swift
//  BBS_v3_community
//
//  Created by 张毓丹 on 2018/4/1.
//  Copyright © 2018年 张毓丹. All rights reserved.
//

import UIKit
import ObjectMapper

class ForumListTableViewCell: UITableViewCell {
    //全局定义屏宽
    let widthOfItemInCell = Variables.screenWidth / 4

    var modelButton = UIButton()

    var isHot = false  //R242 G104 B14
    var hotBoard = ["段子手", "音乐汇", "文学艺术", "鹊桥", "青年湖", "绿茵足球", "招聘信息", "找工作"]
    var defaultFaceArray = ["(๑•̀ㅂ•́)و✧", " ", " o(*≧▽≦)ツ", "ヽ(✿ﾟ▽ﾟ)ノ", "o(^▽^)o", "(ง •_•)ง", "￣O￣)ノ"]

    var buttonTapped: ((Int) -> Void)?
    //broad button
    //装board的数组，从里面拿到board的name
    //var boardArray: [BoardModel] = []
    var numOfButtonInStack = 0

    var buttonNameArray : [String] = []

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    // func initUI(forumName: String, boardArray: [BoardModel], numButtonInStack: Int) {
    func initUI(forumName: String, numButtonInStack: Int, boardArray: [BoardModel]) {

        for a in 0 ..< numButtonInStack * 3{
            if a < boardArray.count{
                buttonNameArray.append(boardArray[a].name)
            }
            else {
                buttonNameArray.append(defaultFaceArray[1])
            }
        }
        //定义相关变量，消除Magic Number
        let heightOfCell = CGFloat(numButtonInStack) * Variables.screenWidth / 8
        let imageCenterX = Variables.screenWidth / 8
        let titleCenterX = Variables.screenWidth / 8
        let imageCenterY = heightOfCell / 2  - 15
        let titleCenterY = heightOfCell / 2  + 17

        contentView.frame = UIScreen.main.bounds
        numOfButtonInStack = numButtonInStack

        modelButton = UIButton(frame: CGRect(x: 0, y: 0, width: Variables.screenWidth/4, height: CGFloat(numButtonInStack) * Variables.screenWidth / 8))

        let myTitleLabel = UILabel(text: "\(forumName)")
        myTitleLabel.frame = CGRect(x: 0, y: 0, width: 64, height: 20)
        myTitleLabel.center = CGPoint(x: titleCenterX, y: titleCenterY)
        myTitleLabel.font = UIFont(name: "AppleGothic", size: 16)

        let myImageView = UIImageView(image: UIImage.init(named: "\(forumName)"))
        myImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        myImageView.center = CGPoint(x: imageCenterX, y: imageCenterY)

        modelButton.addSubview(myImageView)
        modelButton.addSubview(myTitleLabel)
        modelButtonLayout(heightForRow: heightOfCell )

        if #available(iOS 10.0, *) {
            buttonLayout(numberOfButton: numButtonInStack)
        } else {
            // Fallback on earlier versions
        }

    }

    func defaultInit() {
        modelButton.setTitle("   ", for: .normal)

    }

    func modelButtonLayout(heightForRow: CGFloat) {
        print("modelButtonLayout")
        modelButton.backgroundColor = .white
        modelButton.layer.borderWidth = 0.8
        modelButton.layer.borderColor = UIColor.white.cgColor

        self.contentView.addSubview(modelButton)
    }


    func buttonLayout(numberOfButton: Int) {
        let heightOfButton = Variables.screenWidth / 8
        print("buttonLayout")
        for j in 1...3 {
            for i in 0 ..< numberOfButton {
                let button = UIButton(frame: CGRect(x: widthOfItemInCell * CGFloat(j), y: 0 + heightOfButton * CGFloat(i), width: widthOfItemInCell, height: widthOfItemInCell / 2))
                //通过计算给每个button编号，下标从1开始，从左往右，从上往下蛇形遍历
                let index  = i * 3 + j
                button.backgroundColor = .clear
                button.setTitle(buttonNameArray[index - 1], for: .normal)
                button.setTitleColor(.black, for: .normal)
                if hotBoard.first(where: { $0 == buttonNameArray[index - 1] }) != nil { button.setTitleColor(.BBSHotOrange, for: .normal)
                } else {
                    button.setTitleColor(.black, for: .normal)
                }
                
                button.titleLabel?.font = UIFont.HHflexibleFont(ofBaseSize: 15)
                button.layer.borderColor = UIColor.BBSLightGray.cgColor
                button.layer.borderWidth = 0.5
                //button.layer.masksToBounds = true
                button.tag = index
                button.addTarget(self, action: #selector(boardButtonTapped(sender:)), for:
                    .touchUpInside)

                self.contentView.addSubview(button.viewWithTag(index)!)
            }
        }
    }
    func boardButtonTapped(sender: UIButton) {
        print(sender.tag)
        buttonTapped?(sender.tag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//字体大小根据不同机型适配

