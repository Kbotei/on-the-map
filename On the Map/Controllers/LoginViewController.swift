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
        guard let user = email.text, let password = password.text else {
            showAlert("Login Error", message: "Please enter an email/username and password.")
            return
        }
        
        UdacityClient.login(username: user, password: password) {
            [weak self] response, error in
            
            guard error == nil else {
                self?.showAlert("Login Error", message: error?.localizedDescription)
                return
            }
            
            self?.performSegue(withIdentifier: "pushToMap", sender: nil)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(url) else {
                showAlert("Error", message: "Unable to open signup link")
                return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

