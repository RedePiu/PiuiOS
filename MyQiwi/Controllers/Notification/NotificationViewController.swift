//
//  NotificationViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class NotificationViewController: UIBaseViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    lazy var notificationRN = NotificationRN(delegate: self)
    var notifications: [PushResponse] = []
    //lazy var
    
    // MARK: Ciclo de Vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.backgroundColor = UIColor.clear
        
        self.getNotificationList()
        
    }
    
    override func setupViewWillAppear() {
        
        self.hideAll()
        self.lbEmpty.superview?.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNib() {
        
        self.tableView.register(NotificationCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    func setupHeightTable() {
        
        self.height.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            //self.layoutIfNeeded()
        }
    }
}

extension NotificationViewController {
    
    func changeLayout() {
        
        DispatchQueue.main.async {
            
            self.hideAll()
            self.viewLoading.isHidden = true
            self.getNotificationList()
            
        }
    }
    
    func getNotificationList() {
        self.notifications = self.notificationRN.getNotifications()
        self.viewLoading.isHidden = true
        
        if !self.notifications.isEmpty {
            self.tableView.reloadData()
            
//            if !self.notifications.isEmpty {
//                self.tableView.isHidden = false
//                self.viewEmpty.isHidden = true
//                return
//            }
        
            self.tableView.isHidden = false
            self.viewEmpty.isHidden = true
            
            return
        }
        
        self.tableView.isHidden = false
        self.viewEmpty.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension NotificationViewController {
    
    @objc func onClickRemove(sender: UIButton) {
        self.notificationRN.deleteNotification(notification: self.notifications[sender.tag])
        self.getNotificationList()
    }
}

extension NotificationViewController : BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
        
            if fromClass == NotificationRN.self {
            
                if result {
                    
                    self.tableView.isHidden = false
                    self.getNotificationList()
                }
            }
        }
    }
}

extension NotificationViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.height.constant = size.height
                    return
                }
            }
        }
        
        self.height.constant = self.tableView.contentSize.height
    }
}

extension NotificationViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NotificationCell
        
        let index = indexPath.row
        let item = self.notifications[index]
        cell.btnDelete.tag = index
        
        cell.item = item
        cell.btnDelete.addTarget(self, action: #selector(onClickRemove(sender:)), for: .touchUpInside)
        
        if (indexPath.row % 2 == 0) {
            
            cell.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorGrey2)
        } else {
            
            cell.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //return UITableViewAutomaticDimension
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 222
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
}

extension NotificationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension NotificationViewController {
    
    @objc func removeItem(sender: UIButton) {
        
        self.removeFromParentViewController()
    }
    
    func hideAll() {
        self.tableView.superview?.isHidden = false
        self.lbEmpty.superview?.isHidden = true
    }
    
    func loadList() {
        
        self.tableView.reloadData()
    }
}

extension NotificationViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsMessage(self.lbEmpty)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "notification_toolbar_title".localized)
        self.lbEmpty.text = "notification_no_content".localized
    }
}
