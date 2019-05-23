//
//  ChatVC.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 08/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore



class ChannelVC: TechBenchVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBottom: NSLayoutConstraint!
    
    
    var messages = [Message]()
    override var randomColor: UIColor {
        return UIColor(red: 0, green: randomCGFloat, blue: 0, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(channel)
        let swipeLeftGestrue = UISwipeGestureRecognizer(target: self, action: #selector(textFieldSwipedLeft))
        swipeLeftGestrue.direction = .left
        textField.addGestureRecognizer(swipeLeftGestrue)
        
        let swipeRightGestrue = UISwipeGestureRecognizer(target: self, action: #selector(textFieldSwipedRight))
        swipeLeftGestrue.direction = .right
        textField.addGestureRecognizer(swipeRightGestrue)
        
        Firestore.firestore().collection("channel").document(channel).collection("message").order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {return}
            self.messages = snapshot.documents.compactMap { (document) -> Message? in
                return Message(dictionary: document.data())
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.messages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
                }
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            dismiss(animated: false, completion: nil)
            return
        }
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func textFieldSwipedLeft() {
        print("hey")
        textField.text = ""
    }
    
    @objc func textFieldSwipedRight() {
        guard let text = textField.text, !text.isEmpty,
            let userEmail = Auth.auth().currentUser?.email
        else {
            return
        }
        textField.text = ""
        
        let message = Message(sender: userEmail, text: text, timestamp: Timestamp())
        Firestore.firestore().collection("channel").document(channel).collection("message").addDocument(data: message.dictionary)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        textFieldBottom.constant = getKeyboardHeight(notification)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldBottom.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
}


extension ChannelVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    
}
