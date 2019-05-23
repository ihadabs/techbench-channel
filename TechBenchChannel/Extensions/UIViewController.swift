//
//  UIViewController.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 10/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import UIKit



extension UIViewController {

    func addTapGestrue(numberOfTapsRequired: Int, action: Selector) {
        let tapGestrue = UITapGestureRecognizer(target: self, action: action)
        tapGestrue.numberOfTapsRequired = numberOfTapsRequired
        view.addGestureRecognizer(tapGestrue)
    }
}
