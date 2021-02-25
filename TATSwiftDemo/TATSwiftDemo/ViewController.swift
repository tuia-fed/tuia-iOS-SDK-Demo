//
//  ViewController.swift
//  TATSwiftDemo
//
//  Created by zhen yang on 2021/1/26.
//

import UIKit
import TATMediaSDK
fileprivate let reuseID = "cellIdentifier"
class ViewController: UIViewController {
    var tableView : UITableView?
    var titleArray : [(name : String, slotID : String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 119.0/255.0, green: 211.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        self.navigationItem.title = "入口"
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        self.automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        print(TATSimpleAdType.banner.rawValue)
    }
    func setupTableView() -> Void {
        self.titleArray = TATMediaManager.slotDataDictionary()
        let frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 88)
        self.tableView = UITableView(frame: frame, style: .grouped)
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.backgroundColor = UIColor.init(red: 119.0/255.0, green: 211.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        if let tmpTableView = self.tableView {
            self.view.addSubview(tmpTableView)
        }
    }

    
    func gotoAdVC(withType type : TATSimpleAdType) -> Void {
        let vc = TATSimpleAdViewController(WithAdtype: type)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// 用于实现UITableViewDataSource、UITableViewDelegate两个协议中方法的分类
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.titleArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        cell.textLabel?.text = self.titleArray?[indexPath.row].name ?? ""
        cell.textLabel?.textColor = UIColor.black
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let adType : TATSimpleAdType = TATSimpleAdType(rawValue: self.titleArray?[indexPath.row].slotID ?? "banner") {
            gotoAdVC(withType: adType)
        }
    }
}
