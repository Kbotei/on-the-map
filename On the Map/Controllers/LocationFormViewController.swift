//
//  LocationFormViewController.swift
//  On the Map
//
//  Created by Kbotei on 12/5/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit

class LocationFormViewController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        guard locationField.text != nil else {
            showAlert(Alerts.GeneralError, message: Alerts.LocationRequiredMessage)
            return
        }
        
        performSegue(withIdentifier: "findLocation", sender: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "findLocation" {
            let controller = segue.destination as! LocationMapViewController
            controller.location = locationField.text
            controller.link = linkField.text
        }
    }
}
