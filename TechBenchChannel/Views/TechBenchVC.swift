//
//  TechBenchVC.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 10/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import UIKit

class TechBenchVC: UIViewController {
    
    var isGlowing = false
    var timer: Timer?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var randomCGFloat: CGFloat {
        return CGFloat.random(in: 0.1...1)
    }
    
    var randomColor: UIColor {
        return UIColor(red: randomCGFloat, green: randomCGFloat, blue: randomCGFloat, alpha: 1)
    }

    let logoView: UIImageView = {
        let logo = UIImage(named: "logo")!.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true

        view.addSubview(logoView)
        view.isUserInteractionEnabled = true
    
        logoView.widthAnchor.constraint(equalToConstant: 96).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGlowing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stopGlowing()
        glow()
    }
    
    @objc func glow() {
        logoView.tintColor = randomColor
        UIView.animate(withDuration: 0.1, animations: {
            self.logoView.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.logoView.alpha = 0
            })
        }
    }
    
    @objc func startGlowing() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(glow), userInfo: nil, repeats: true)
    }
    
    func stopGlowing() {
        timer?.invalidate()
        timer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        glow()
        view.endEditing(true)
    }

}
