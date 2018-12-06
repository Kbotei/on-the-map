//
//  LoginViewController.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func login(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            showAlert(Alerts.GeneralError, message: Alerts.LoginEmptyMessage)
            return
        }
        
        UdacityClient.login(username: email, password: password) {
            [weak self] response, error in
            
            guard error == nil else {
                self?.showAlert(Alerts.GeneralError, message: error?.localizedDescription)
                return
            }
            
            self?.emailField.text = nil
            self?.passwordField.text = nil
            
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

