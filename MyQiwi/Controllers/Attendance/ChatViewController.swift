
//
//  ChatTableViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomContainer: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    
    @IBOutlet weak var btSend: UIButton!
    
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var imgRobot: UIImageView!
    @IBOutlet weak var lbRobotQiwi: UILabel!
    @IBOutlet weak var lbRobotStatus: UILabel!
    
    // MARK: Variables
    
    var messages: [Message] = [
        Message(body: "Olá, teste chat!", time: Util.stringHoursSeconds(), isMine: false)
    ]
    
    var answerAndQuestions: [AttendanceQuestionAndAnswer] = []
    
    // MARK: Ciclo de vida
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupTexts()
        self.setupTableView()
        
        self.registerObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeObservers()
    }
}

// MARK: Selectors
extension ChatViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        self.bottomContainer.constant = keyboardFrame.height
        
        // Animation
        UIView.animate(withDuration: TimeInterval(truncating: keyboardAnimationDuration)) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        guard let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        self.bottomContainer.constant = 0
        
        // Animation
        UIView.animate(withDuration: TimeInterval(truncating: keyboardAnimationDuration)) {
            self.view.layoutIfNeeded()
        }
    }
}


// MARK: - Table view data source / delegate
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        cell.message = self.messages[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

// MARK: Data Source Collection
extension ChatViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        return UICollectionViewCell()
    }
}

// MARK: Delegate Collection
extension ChatViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.sendMessage(sender: UIButton())
    }
}

// MARK: IBActions
extension ChatViewController {
    
    @IBAction func sendMessage(sender: UIButton) {
        
        self.textField.resignFirstResponder()
        
        if let body = textField.text {
            
            self.messages.append(Message(body: body, time: Util.stringHoursSeconds(), isMine: true))
            self.messages.append(Message(body: "Por favor, selecione um dos pedidos da lista para continuar.", time: Util.stringHoursSeconds(), isMine: false))
            self.textField.text = nil
            
            if body.isEmpty {
                self.messages.append(Message(body: "Teste \(RAND_MAX)", time: Util.stringHoursSeconds(), isMine: true))
                self.messages.append(Message(body: "Não entendi..", time: Util.stringHoursSeconds(), isMine: false))
            }
        }
        
        DispatchQueue.main.async {

            self.tableView.reloadData()
            
            let section = self.messages.isEmpty ? 0 : self.messages.count - 1
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .bottom, animated: true)
        }
    }
    
}

extension ChatViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        
        self.navigationItem.titleView = viewTitle
        self.imgRobot.layer.cornerRadius = self.imgRobot.frame.height / 2
        self.imgRobot.layer.masksToBounds = false
        self.imgRobot.clipsToBounds = true
        
        btSend.imageView?.contentMode = .scaleAspectFit
        btSend.imageView?.center = btSend.center
        btSend.setImage(btSend.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        btSend.imageView?.tintColor = .white
        btSend.backgroundColor = Theme.default.orange
        btSend.layer.cornerRadius = btSend.frame.height / 2
        btSend.layer.masksToBounds = false
        btSend.layer.addShadow()
    }
    
    func setupTexts() {
        
        Util.setTextBarIn(self, title: "")
        
        self.lbRobotQiwi.text = "attendance_robot_qiwi".localized
        self.lbRobotStatus.text = "attendance_default_status".localized
    }
    
    func setupTableView() {
        self.tableView.register(MessageCell.nib(), forCellReuseIdentifier: "MessageCell")
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    }
    
    func registerObservers() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeObservers() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
