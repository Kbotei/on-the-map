//
//  UIViewController+Alert.swift
//  Pull this in from the PitchPerfect project
//
//  Created by Kbotei on 8/7/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: Alerts
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let GeneralError = "An Error Occurred"
        static let GeneralMessage = "An error occurred, please try again."
    }
    
    public func showAlert(_ title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message ?? Alerts.GeneralMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
