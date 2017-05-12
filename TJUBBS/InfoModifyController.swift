//
//  InfoModifyController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/1.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

enum InfoModifyStyle {
    case rightTop
    case bottom
    case custom
}

class InfoModifyController: UIViewController {
    var tableView: UITableView! = nil
    var items: [InputItem] = []
    var headerMsg: String? = "修改信息"
    var customView: UIView? = nil
    var customCallback: ((Any)->())?
    var handler: ((Any)->())? = nil
    var results: [String : String] = [:]
    var style: InfoModifyStyle = .bottom
    var doneView: UIView? = nil
    var doneText = "完成"
    
    convenience init(title: String, items: [InputItem] = [], style: InfoModifyStyle, headerMsg: String? = nil, handler: ((Any)->())?) {
        self.init()
        self.items = items
        self.title = title
        self.headerMsg = headerMsg
        self.handler = handler
        self.style = style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        
        self.view.addSubview(tableView)
        // 初始化完成操作View
        if style == .rightTop || style == .custom {
            let rightButton = UIBarButtonItem(title: doneText, style: .done, target: self, action: #selector(self.doneTapped))
            self.navigationItem.rightBarButtonItem = rightButton
            self.navigationItem.rightBarButtonItem?.isEnabled = results.count == items.count
        } else if style == .bottom {
            let screenFrame = UIScreen.main.bounds
            doneView = UIView(frame: CGRect(x: 0, y: 30, width: screenFrame.width, height: screenFrame.height*(300/1920)))
            let button = UIButton(title: doneText, isConfirmButton: true)
            doneView?.addSubview(button)
            button.snp.makeConstraints {
                make in
                make.centerY.equalTo(doneView!)
                make.centerX.equalTo(doneView!)
                make.width.equalTo(screenFrame.width*(800/1080))
                make.height.equalTo(screenFrame.height*(100/1920))
            }
            button.addTarget(self, action: #selector(self.doneTapped), for: .touchUpInside)
            button.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension InfoModifyController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        if item.type == .textField {
            let cell = TextInputCell(title: item.title, placeholder: item.placeholder)
            // 设置textField
            // 作为索引
            cell.textField?.tag = indexPath.row
            cell.textField?.isSecureTextEntry = item.isSecure
            cell.textField?.autocorrectionType = .no
            cell.textField?.autocapitalizationType = .none
            cell.textField?.spellCheckingType = .no
            cell.textField?.clearButtonMode = .whileEditing
            cell.textField?.delegate = self
            // 更新结果
            cell.textField?.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
            return cell
        } else {
            let cell = TextInputCell(title: item.title, placeholder: item.placeholder, type: .textView)
            // 设置textField
            // 作为索引
            cell.textView?.tag = -1 - indexPath.row
            cell.textView?.isSecureTextEntry = item.isSecure
            cell.textView?.autocorrectionType = .no
            cell.textView?.autocapitalizationType = .none
            cell.textView?.spellCheckingType = .no
            cell.textView?.text = item.placeholder
            cell.textView?.textColor = UIColor(red:0.52, green:0.53, blue:0.53, alpha:1.00)
            cell.textView?.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerMsg == nil ? 0.1 : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerMsg != nil {
            return  {
                let label = UILabel(text: "    "+headerMsg!)
                label.font = UIFont.systemFont(ofSize: 13)
                return label
                }()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch style {
        case .bottom:
            return doneView?.frame.height ?? 40
        case .rightTop:
            return 0
        case .custom:
            return customView?.frame.height ?? 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if style == .bottom {
            return doneView
        } else if style == .custom {
            return customView
        }
        if customView != nil {
            return customView
        }
        return nil
    }
    
    func doneTapped() {
        if style != .custom {
            handler?(self.results)
        } else {
            for tView in customView!.subviews {
                // 如果找到 textView
                if let textView = tView as? UITextView {
                    handler?(textView.text)
                    return
                }
                // 如果找到 textField
                if let textField = tView as? UITextField {
                    handler?(textField.text as Any)
                    return
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? TextInputCell {
            cell.textField?.becomeFirstResponder()
            cell.textView?.becomeFirstResponder()
        }
    }
}

extension InfoModifyController: UITextFieldDelegate {
    func textChange(_ textField: UITextField) {
        if textField.hasText {
            // save result
            let item = items[textField.tag]
            results.updateValue(textField.text!, forKey: item.rawName)
        } else {
            let item = items[textField.tag]
            results.removeValue(forKey: item.rawName)
        }
        if style == .bottom {
            if let btn = doneView?.subviews.first as? UIButton {
                btn.isEnabled = results.count == items.count
            }
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = results.count == items.count
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let cell = textField.superview?.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let row = indexPath.row + 1
            if row >= items.count {
                textField.resignFirstResponder()
                UIView.animate(withDuration: 0.3) {
                    self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
                }
                doneTapped()
                return true
            }
            let nextIndex = IndexPath(row: row, section: indexPath.section)
            let cell = tableView.cellForRow(at: nextIndex) as? TextInputCell
            cell?.textField?.becomeFirstResponder()
            cell?.textView?.becomeFirstResponder()
            return true
        }
        return false
    }
    
    func moveUpwards(_ cell: UITableViewCell) {
        let screenHeight = UIScreen.main.bounds.height
        if style == .rightTop {
            let offset = cell.center.y - screenHeight/4
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame = CGRect(x: 0, y: -offset, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
            }
        } else if style == .bottom {
            let offset = cell.center.y - screenHeight/4
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame = CGRect(x: 0, y: -offset, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? TextInputCell, let indexPath = tableView.indexPath(for: cell) {
            let row = indexPath.row
//            let limit = (style == .bottom) ? 2 : (style == .rightTop) ? 3 : 0
            let iPhonePlusWidth: CGFloat = 414.0
            let limit = (style == .custom) ? 0 : (UIScreen.main.bounds.width >= iPhonePlusWidth) ? 5 : 2
            if row <= limit || row >= items.count {
                UIView.animate(withDuration: 0.3) {
                    self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
                }
                return
            }
            moveUpwards(cell)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        }
    }
    
}

extension InfoModifyController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.tag < 0 {
            textView.textColor = UIColor.black
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.tag < 0 {
            let itemIndex = -(textView.tag + 1)
            textView.textColor = UIColor(red:0.52, green:0.53, blue:0.53, alpha:1.00)
            textView.text = items[itemIndex].placeholder
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textColor = UIColor.black
        let count = textView.text.characters.count
        self.customCallback?(count)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location >= 50 {
            if text.isEmpty {
                return true
            }
            return false
        } else {
            return true
        }
    }
}
