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
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        self.view.addSubview(tableView)
        // 初始化完成操作View
        if style == .rightTop {
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
        let cell = TextInputCell(title: item.title, placeholder: item.placeholder)
        // 设置textField
        // 作为索引
        cell.textField?.tag = indexPath.row
        cell.textField?.isSecureTextEntry = item.isSecure
        cell.textField?.autocorrectionType = .no
        cell.textField?.autocapitalizationType = .none
        cell.textField?.spellCheckingType = .no
        cell.textField?.delegate = self
        // 更新结果
        cell.textField?.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
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
        return nil
    }
    
    func doneTapped() {
        if style != .custom {
            handler?(self.results)
        } else {
            for v in customView!.subviews {
                if let textView = v as? UITextView {
                    handler?(textView.text)
                    return
                }
                if let textField = v as? UITextField {
                    handler?(textField.text)
                    return
                }
            }
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
            return true
        }
        return false
    }
    
    func moveUpwards(_ cell: UITableViewCell) {
        let screenHeight = UIScreen.main.bounds.height
        if style == .rightTop {
            let offset = cell.frame.origin.y - screenHeight/4
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame = CGRect(x: 0, y: -offset, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
            }
        } else if style == .bottom {
            let offset = cell.frame.origin.y - screenHeight/4
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
