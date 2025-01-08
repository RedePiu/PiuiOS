
//
//  ChatTableViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
//    var containerView: UIView {
//
//        let containerView = UIView(frame: .zero)
//        let textfield = UITextField(frame: .zero)
//        containerView.addSubview(textfield)
//        return containerView
//    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    var messages: [Message] = [
        Message(),
        Message()
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(MessageCell.nib(), forCellReuseIdentifier: "MessageCell")
        
        let textfield = UITextField(frame: .zero)
        
        containerView.addSubview(textfield)
        
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 0).isActive = true
//        containerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor, constant: 0).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        textfield.translatesAutoresizingMaskIntoConstraints = false
//        textfield.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
//        textfield.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, constant: 0).isActive = true
//        textfield.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        self.containerView.bringSubview(toFront: self.tableView)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.messages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.tvText.textColor = .white
        cell.tvText.backgroundColor = Theme.default.primary
        cell.tvText.layer.cornerRadius = 10
        cell.tvText.layer.masksToBounds = false

//        let message = self.messages[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
