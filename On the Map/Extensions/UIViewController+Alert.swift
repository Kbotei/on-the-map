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
        static let LoginEmptyMessage = "Please enter an email/username and password."
        static let SignupLinkMessage = "Unable to open signup link"
        static let LocationRequiredMessage = "Please enter a location."
        static let LocationEmptyMessage = "Location is empty, please go back and enter a location!"
        static let LocationSearchMessage = "There was an error searching for the location!"
        static let LocationSaveMessage = "Unable to save location, please try again."
        static let CannotOpenLink = "Unable to open that type of link"
    }
    
    public func showAlert(_ title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message ?? Alerts.GeneralMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
