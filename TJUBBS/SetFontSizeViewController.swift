//
//  SetFontSizeViewController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/8/24.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class SetFontSizeViewController: UIViewController {
    let minSize = 10
    let maxSize = 30
    
    var sizeSlider: UISlider!
    var previewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectedSize = BBSUser.shared.fontSize
        sizeSlider = UISlider()
        sizeSlider.minimumValue = Float(minSize)
        sizeSlider.maximumValue = Float(maxSize)
        sizeSlider.isContinuous = false
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
        minLabel.center.y = self.view.height/6
        
        maxLabel.x = self.view.width - 10 - maxLabel.width
        maxLabel.center.y = minLabel.y

        sizeSlider.x = minLabel.x + minLabel.width + 10
        sizeSlider.center.y = minLabel.y
        sizeSlider.width = self.view.width - 10*2 - 10*2 - minLabel.width - maxLabel.width
        sizeSlider.height = maxLabel.height
        
        previewLabel.x = 20
        previewLabel.y = minLabel.y + minLabel.height + 40
        previewLabel.width = self.view.width - 20*2
        previewLabel.text = "ksjdkasjdjhaksjhdashdakjshdkj中 is 的烦恼卡将会是大声疾呼打卡技术的科技啊开始觉得哈速度"
        previewLabel.sizeToFit()
        
        self.view.addSubview(minLabel)
        self.view.addSubview(maxLabel)
        self.view.addSubview(sizeSlider)
        self.view.addSubview(previewLabel)
    }

    func onSliderValueChanged(slider: UISlider) {
        previewLabel.font = UIFont.systemFont(ofSize: CGFloat(slider.value))
        previewLabel.sizeToFit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BBSUser.shared.fontSize = Int(sizeSlider.value)
        BBSUser.save()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
