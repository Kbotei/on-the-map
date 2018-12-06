//
//  InfoPostViewController.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var locations: [StudentInformation] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocations()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
    }
    
    func getLocations(refresh: Bool = false) {
        if StudentData.locations.count > 0, !refresh {
            getLocations(locations: StudentData.locations, error: nil)
        } else {
            ParseClient.getStudentLocations(completion: getLocations(locations:error:))
        }
    }
    
    
    // MARK: - Completion Methods
    
    func getLocations(locations: [StudentInformation], error: Error?) {
        guard locations.count > 0 else {
            showAlert(Alerts.GeneralError, message: error?.localizedDescription)
            return
        }
        
        self.locations = locations
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout { [weak self] success, error in
            if !success {
                self?.showAlert(Alerts.GeneralError, message: error?.localizedDescription)
            }
        }
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        getLocations(refresh: true)
        tableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "location"),
            let firstName = locations[indexPath.row].firstName, let lastName = locations[indexPath.row].lastName,
            let url = locations[indexPath.row].mediaURL else {
                return UITableViewCell()
        }
        
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.detailTextLabel?.text = url
        
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard locations.count > indexPath.row else {
            showAlert(Alerts.GeneralError, message: "That pin may not exist please refresh and try again.")
            return
        }
        
        let location = locations[indexPath.row]
            
        if let link = location.mediaURL, let url = URL(string: link),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
