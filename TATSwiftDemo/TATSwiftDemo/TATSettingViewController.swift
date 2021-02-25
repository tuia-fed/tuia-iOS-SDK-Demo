//
//  TATSettingViewController.swift
//  TATSwiftDemo
//
//  Created by zhen yang on 2021/2/1.
//

import UIKit
import TATMediaSDK
import CoreLocation
fileprivate let reuseID = "cellIdentifier"

class TATSettingViewController: UIViewController {
    
    var dataArray : [String]!
    
    var tableView : UITableView!
    
    var floatView : UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = ["设置用户ID", "设置device ID"]
        let frame = CGRect(x: 0, y: 88, width: self.view.bounds.width, height: self.view.bounds.height - 88)
        self.tableView = UITableView(frame: frame, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = UIColor.init(red: 119.0/255.0, green: 211.0/255.0, blue: 220.0/255.0, alpha: 1.0)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showFloatAd()
    }
    
    func showFloatAd() -> Void {
        let adView = TATMediaCenter.initSimpleAd(withSlotId: TATMediaManager.slotIdForType(.float)) { [weak self](result, error) in
            if result {
                if var frame = self?.floatView?.frame {
                    let originX = UIScreen.main.bounds.width - frame.width - 16
                    frame.origin.x = originX
                    frame.origin.y = UIScreen.main.bounds.height - frame.height - 116
                    self?.floatView?.frame = frame
                }
                
            }
        }
        adView?.clickAdBlock = {(slotId : String?) -> Void in
            let message = "点击广告位回调:\(slotId ?? "nil")"
            let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.floatView?.removeFromSuperview()
        self.floatView = nil
        self.view.addSubview(adView!)
        self.floatView = adView
    }
    
    func showUserIdInputField() -> Void {
        let alert = UIAlertController(title: "设置用户ID", message: "~", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = alert.textFields?.first?.text {
                self.setUserId(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "用户ID"
            textField.keyboardType = .numberPad
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showInputDeviceIdField() -> Void {
        let alert = UIAlertController(title: "设置device ID", message: "请输入device_id", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = alert.textFields?.first?.text {
                self.setDeviceId(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "device ID"
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }


    func setUserId(_ userID : String?) -> Void {
        guard let innerUserID = userID else {
            return
        }
        let set = CharacterSet.whitespacesAndNewlines
        let useUserID = innerUserID.trimmingCharacters(in: set)
        TATUserManager.sharedInstance.setUserId(useUserID)
        tableView.reloadData()
    }
    
    func setDeviceId(_ deviceID : String?) -> Void {
        guard let innerDeviceID = deviceID else {
            return
        }
        let set = CharacterSet.whitespacesAndNewlines
        let useDeviceID = innerDeviceID.trimmingCharacters(in: set)
        TATUserManager.sharedInstance.setDeviceId(useDeviceID)
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK:    -   懒加载
    lazy var manager : CLLocationManager = {
        let manager : CLLocationManager = CLLocationManager()
        return manager
    }()
}
// 用于实现UITableViewDataSource、UITableViewDelegate两个协议中方法的分类
extension TATSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reuseID)
            cell?.textLabel?.text = self.dataArray[indexPath.row]
            cell?.selectionStyle = .none
            cell?.accessoryType = .disclosureIndicator
        }
        if indexPath.row == 0 {
            cell?.detailTextLabel?.text = TATUserManager.sharedInstance.userId
        } else if indexPath.row == 1 {
            cell?.detailTextLabel?.text = TATUserManager.sharedInstance.deviceId;
        } else {
            cell?.detailTextLabel?.text = ""
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showUserIdInputField()
        } else if indexPath.row == 1 {
            showInputDeviceIdField()
        }
    }
}
