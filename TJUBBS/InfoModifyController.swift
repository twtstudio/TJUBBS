//
//  InfoModifyController.swift
//  TJUBBS
//
//  Created by Halcao on 2017/5/1.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class InfoModifyController: UIViewController {
    var tableView: UITableView! = nil
    var items: [InputItem] = []
    var headerMsg: String? = "修改信息"
    var footerView: UIView? = nil
    var handler: ((Any)->())? = nil
    var results: [String : String] = [:]
    
    convenience init(title: String, items: [InputItem], headerMsg: String? = nil, handler: ((Any)->())?) {
        self.init()
        self.items = items
        self.title = title
        self.headerMsg = headerMsg
        self.handler = handler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
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
        cell.textField?.isSecureTextEntry = item.isSecure
        cell.textField?.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UILabel(text: headerMsg!)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.footerView != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doneTapped))
            footerView?.addGestureRecognizer(tapGesture)
            return footerView
        } else {
            let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneTapped))
            self.navigationItem.rightBarButtonItem = rightButton
            return UIView()
        }
    }
    
    func doneTapped() {
        handler?(self.results)
    }
}

extension InfoModifyController: UITextFieldDelegate {
    func textChange(_ textField: UITextField) {
        let item = items[textField.tag]
        results.updateValue(textField.text!, forKey: item.rawName)
    }
}
