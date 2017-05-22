//
//  AddThreadViewController.swift
//  TJUBBS
//
//  Created by JinHongxu on 2017/5/15.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import PKHUD

class AddThreadViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    var tableView = UITableView(frame: .zero, style: .grouped)
    var forumList: [ForumModel] = []
    var boardList: [BoardModel] = []
    var openForumListFlag = false
    var openBoardListFlag = false
    var selectedForum: ForumModel? {
        didSet {
            openForumListFlag = false
            forumString = "讨论区：\(selectedForum?.name ?? " ")"
            tableView.reloadSections([0], with: .automatic)
            selectedBoard = nil
        }
    }
    var selectedBoard: BoardModel? {
        didSet {
            openBoardListFlag = false
            boardString = "板块：\(selectedBoard?.name ?? " ")"
            tableView.reloadSections([1], with: .automatic)
        }
    }
    var forumString = "讨论区"
    var boardString = "板块"
    let themeCell = TextInputCell(title: "主题", placeholder: "帖子的主题")
    let detailCell = TextInputCell(title: "帖子正文", placeholder: "有什么想说的呢", type: .textView)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        // 把返回换成空白
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        self.title = "发帖"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func doneButtonTapped() {
        
        guard selectedBoard != nil else {
            HUD.flash(.label("请先选择板块"))
            return
        }
        
        guard (themeCell.textField?.text?.characters.count)! > 0 else {
            HUD.flash(.label("请填写主题"))
            return
        }
        
        guard (detailCell.textView?.text.characters.count)! > 0 else {
            HUD.flash(.label("请填写帖子详情"))
            return
        }

        BBSJarvis.postThread(boardID: selectedBoard!.id, title: themeCell.textField?.text ?? "", content: detailCell.textView?.text ?? "") { _ in
            HUD.flash(.success)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddThreadViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 + (openForumListFlag ? forumList.count : 0)
        case 1:
            return 1 + (openBoardListFlag ? boardList.count : 0)
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = forumString
                
                let rightImageView = UIImageView(image: UIImage(named: openForumListFlag ? "upArrow" : "downArrow"))
                cell.contentView.addSubview(rightImageView)
                rightImageView.snp.makeConstraints {
                    make in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-16)
                    make.height.width.equalTo(screenSize.height*(88/1920))
                }
                
                rightImageView.addTapGestureRecognizer {
                    sender in
                    if self.openForumListFlag == false {
                        BBSJarvis.getForumList {
                            dict in
                            self.openForumListFlag = true
                            if let data = dict["data"] as? [[String: Any]] {
                                self.forumList = Mapper<ForumModel>().mapArray(JSONArray: data) ?? []
                            }
                            var indexPathArray: [IndexPath] = []
                            for i in 1...self.forumList.count {
                                indexPathArray.append(IndexPath(row: i, section: 0))
                            }
                            tableView.reloadSections([0], with: .none)
                        }
                    } else {
                        self.openForumListFlag = false
                        tableView.reloadSections([0], with: .automatic)
                    }
                }
                cell.isHidden = !tableView.allowsSelection
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "normalCell")
                cell.textLabel?.text = forumList[indexPath.row-1].name
                
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = boardString
                
                let rightImageView = UIImageView(image: UIImage(named: openBoardListFlag ? "upArrow" : "downArrow"))
                cell.contentView.addSubview(rightImageView)
                rightImageView.snp.makeConstraints {
                    make in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-16)
                    make.height.width.equalTo(screenSize.height*(88/1920))
                }
                
                rightImageView.addTapGestureRecognizer {
                    sender in
                    if self.openBoardListFlag == false {
                        if let forum = self.selectedForum {
                            BBSJarvis.getBoardList(forumID: forum.id) {
                                dict in
                                print("dict: \(dict)")
                                self.openBoardListFlag = true
                                if let data = dict["data"] as? [String: Any],
                                    let boards = data["boards"] as? [[String: Any]] {
                                    self.boardList = Mapper<BoardModel>().mapArray(JSONArray: boards) ?? []
                                }
                                tableView.reloadSections([1], with: .none)
                            }
                        } else {
                            HUD.flash(.label("请先选择讨论区"))
                        }
                    } else {
                        self.openBoardListFlag = false
                        tableView.reloadSections([1], with: .automatic)
                    }
                }
                rightImageView.isHidden = !tableView.allowsSelection
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "normalCell")
                cell.textLabel?.text = boardList[indexPath.row-1].name
                
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
                cell.textLabel?.text = "帖子"
                return cell
            } else if indexPath.row == 1 {
                return themeCell
            } else {
                return detailCell
            }
        default:
            return UITableViewCell()
        }
    }
    
    //TODO: Better way to hide first headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}

extension AddThreadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row != 0 {
            selectedForum = forumList[indexPath.row-1]
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .BBSLightBlue
        } else if indexPath.section == 1 && indexPath.row != 0 {
            selectedBoard = boardList[indexPath.row-1]
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .BBSLightBlue
        }
    }
}


