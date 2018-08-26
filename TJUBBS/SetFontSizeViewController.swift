//
//  SetFontSizeViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/8/24.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class SetFontSizeViewController: UIViewController {
    let minSize = 12
    let maxSize = 25

    var sizeSlider: UISlider!
    var previewLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "字体设置"

        self.view.backgroundColor = .white
        let selectedSize = BBSUser.shared.fontSize
        sizeSlider = UISlider()
        sizeSlider.minimumValue = Float(minSize)
        sizeSlider.maximumValue = Float(maxSize)
//        sizeSlider.isContinuous = false
        sizeSlider.value = Float(selectedSize)
        sizeSlider.addTarget(self, action: #selector(onSliderValueChanged(slider:)), for: .valueChanged)
        previewLabel = UILabel()
        previewLabel.font = UIFont.systemFont(ofSize: CGFloat(selectedSize))
        previewLabel.numberOfLines = 0

        let minLabel = UILabel(text: "A", fontSize: minSize)
        let maxLabel = UILabel(text: "A", fontSize: maxSize)

        minLabel.sizeToFit()
        maxLabel.sizeToFit()

        // layout
        minLabel.x = 10
//        minLabel.center.x = self.view.center.x
        minLabel.center.y = self.view.height/6

        maxLabel.x = self.view.width - 10 - maxLabel.width
        maxLabel.center.y = minLabel.center.y

        sizeSlider.x = minLabel.x + minLabel.width + 10
        sizeSlider.center.y = minLabel.center.y
        sizeSlider.width = self.view.width - 10*2 - 10*2 - minLabel.width - maxLabel.width
        sizeSlider.height = maxLabel.height

//        previewLabel.x = 20
        previewLabel.width = self.view.width - 20*2
//        previewLabel.text = "我知道\n地球的年龄是45.5亿年\n岩浆的温度是700到1200度\n世界上的花大概有45万种\n但是\n相比于这个世界\n我更想"
        previewLabel.text = "出门一笑莫心哀，浩荡襟怀到处开。\n时事难从无过立，达官非自有生来。\n风涛回首空三岛，尘壤从头数九垓。\n休信儿童轻薄语，嗤他赵老送灯台。\n\n力微任重久神疲，再竭衰庸定不支。\n苟利国家生死以，岂因祸福避趋之。\n谪居正是君恩厚，养拙刚于戍卒宜。\n戏与山妻谈故事，试吟断送老头皮。\n"
        previewLabel.sizeToFit()
        previewLabel.center.x = self.view.center.x
        previewLabel.y = minLabel.y + minLabel.height + 40

        self.view.addSubview(minLabel)
        self.view.addSubview(maxLabel)
        self.view.addSubview(sizeSlider)
        self.view.addSubview(previewLabel)
    }

    func onSliderValueChanged(slider: UISlider) {
        previewLabel.font = UIFont.systemFont(ofSize: CGFloat(slider.value))
        previewLabel.width = self.view.width - 20*2
        previewLabel.sizeToFit()
        previewLabel.center.x = self.view.center.x
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BBSUser.shared.fontSize = Int(sizeSlider.value)
        BBSUser.save()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
