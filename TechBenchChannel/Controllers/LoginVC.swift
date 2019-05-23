//
//  LoginVC.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 08/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: TechBenchVC {


    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailFieldTrailing: NSLayoutConstraint!
    @IBOutlet weak var passwordFieldLeading: NSLayoutConstraint!
    

    var isAuthenticating = false
    var viewWidth: CGFloat {
        return view.frame.size.width
    }
    
    override var randomColor: UIColor {
        return UIColor(red: randomCGFloat, green: 0, blue: 0, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailFieldTrailing.constant = viewWidth
        passwordFieldLeading.constant = -viewWidth
        
        emailField.addTarget(self, action: #selector(glow), for: .allEditingEvents)
        passwordField.addTarget(self, action: #selector(glow), for: .allEditingEvents)
        
        addTapGestrue(numberOfTapsRequired: 2, action: #selector(viewTappedTwice(tapGestrue:)))
        addTapGestrue(numberOfTapsRequired: 3, action: #selector(viewTappedThrice(tapGestrue:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "showHome", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stopGlowing()
        glow()
    }
    
    @objc func viewTappedTwice(tapGestrue: UITapGestureRecognizer) {
        
        let touchPoint = tapGestrue.location(in: view)
        
        if (touchPoint.x < viewWidth/2) {
            emailFieldTrailing.constant = 0
            
        } else if (emailFieldTrailing.constant == 0) {
            passwordFieldLeading.constant = 0
        }
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func viewTappedThrice(tapGestrue: UITapGestureRecognizer) {
        
        if isAuthenticating || emailFieldTrailing.constant != 0 || passwordFieldLeading.constant != 0 {
            return
        }

        let touchPoint = tapGestrue.location(in: view)
        
        startAuthenticating()
        
        if (touchPoint.x < viewWidth/2) {
            login()
        } else {
            register()
        }
    }
    
    private func startAuthenticating() {
        isAuthenticating = true
        view.endEditing(true)
        messageLabel.text = ""
        emailFieldTrailing.constant = viewWidth
        passwordFieldLeading.constant = -viewWidth
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        startGlowing()
    }
    
    private func finshAuthenticating() {
        isAuthenticating = false
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "showHome", sender: self)
            return
        }
    
        emailFieldTrailing.constant = 0
        passwordFieldLeading.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        stopGlowing()
    }
    
    
    private func login() {
        
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            self.messageLabel.text = error?.localizedDescription
            self.finshAuthenticating()
        }
        
    }
    
    private func register() {
        
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password)  { (result, error) in
            self.messageLabel.text = error?.localizedDescription
            self.finshAuthenticating()
        }
    }
    
}
