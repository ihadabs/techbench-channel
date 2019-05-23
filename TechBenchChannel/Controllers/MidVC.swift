//
//  MidVC.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 08/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import UIKit
import FirebaseAuth


class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "showLoginVC", sender: self)
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "showLoginVC", sender: self)
        }
        catch { print(error.localizedDescription) }
    }
    
}
