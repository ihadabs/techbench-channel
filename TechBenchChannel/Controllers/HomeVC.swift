//
//  MidVC.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 08/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class HomeVC: TechBenchVC {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var channelField: UITextField!
    @IBOutlet weak var channelFieldLeading: NSLayoutConstraint!
    
    
    var isChecking = false
    override var randomColor: UIColor {
        return UIColor(red: 0, green: 0, blue: randomCGFloat, alpha: 1)
    }
    var viewWidth: CGFloat {
        return view.frame.size.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         channelField.addTarget(self, action: #selector(glow), for: .allEditingEvents)
        
        addTapGestrue(numberOfTapsRequired: 2, action: #selector(viewTappedTwice))
        addTapGestrue(numberOfTapsRequired: 3, action: #selector(viewTappedThrice))
        addTapGestrue(numberOfTapsRequired: 6, action: #selector(signOut))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         channelFieldLeading.constant = viewWidth
        
        if Auth.auth().currentUser == nil {
            dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func viewTappedTwice(tapGestrue: UITapGestureRecognizer) {
        glow()
        channelFieldLeading.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func viewTappedThrice(tapGestrue: UITapGestureRecognizer) {
        glow()
        if isChecking {
            return
        }
        
        startChecking()
        checkChannel()
    }
    
    func startChecking() {
        
        isChecking = true
        view.endEditing(true)
        messageLabel.text = ""
        channelFieldLeading.constant = viewWidth
       
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        startGlowing()
    }
    
    func finshChecking(withError: Bool) {
        isChecking = false
        if !withError {
            channel = channelField.text!
            performSegue(withIdentifier: "showChannel", sender: self)
            return
        }
        
        channelFieldLeading.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        stopGlowing()
    }
    
    func checkChannel() {
        guard let channel = channelField.text, !channel.trimmingCharacters(in: .whitespaces).isEmpty else {
            messageLabel.text = "Channel name can not be empty!"
            finshChecking(withError: true)
            return
        }
        
        Firestore.firestore().collection("channel").document(channel).getDocument { (document, error) in
            if let error = error {
                self.messageLabel.text = error.localizedDescription
                self.finshChecking(withError: true)
                return
            }
            if document?.exists ?? false {
                self.finshChecking(withError: false)
            } else {
                self.createChannel()
            }
        }
    }
    
    func createChannel() {
        guard let channel = channelField.text,
            let userEmail = Auth.auth().currentUser?.email
        else {
            self.finshChecking(withError: true)
            return
        }
        
        
        Firestore.firestore().collection("channel").document(channel).setData(["timestamp": Timestamp(), "createdBy": userEmail]) { (error) in
            if let error = error {
                self.messageLabel.text = error.localizedDescription
                self.finshChecking(withError: true)
                return
            }
            print("Channel created!")
            self.finshChecking(withError: false)
        }
    }
    
    @objc func signOut(tapGestrue: UITapGestureRecognizer) {
        glow()
        do {
            try Auth.auth().signOut()
            dismiss(animated: false, completion: nil)
        }
        catch { print(error.localizedDescription) }
    }
    
}
