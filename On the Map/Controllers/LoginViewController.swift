//
//  LoginViewController.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func login(_ sender: Any) {
        guard let user = email.text, let password = password.text, !user.isEmpty, !password.isEmpty else {
            showAlert(Alerts.GeneralError, message: Alerts.LoginEmptyMessage)
            return
        }
        
        UdacityClient.login(username: user, password: password) {
            [weak self] response, error in
            
            guard error == nil else {
                self?.showAlert(Alerts.GeneralError, message: error?.localizedDescription)
                return
            }
            
            self?.performSegue(withIdentifier: "pushToMap", sender: nil)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(url) else {
                showAlert(Alerts.GeneralError, message: Alerts.SignupLinkMessage)
                return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

