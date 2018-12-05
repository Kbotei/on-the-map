//
//  MapViewController.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ParseClient.getStudentLocations(completion: populateStudentLocations(locations:error:))
    }
    
    // MARK: Completion Methods
    
    func populateStudentLocations(locations: [StudentLocation], error: Error?) {
        guard locations.count > 0 else {
            showAlert(Alerts.GeneralError, message: error?.localizedDescription)
            return
        }
        
        for location in locations {
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            point.title = "\(location.firstName) \(location.lastName)"
            map.addAnnotation(point)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout { [weak self] success, error in
            if !success {
                self?.showAlert("Opps", message: error?.localizedDescription)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
