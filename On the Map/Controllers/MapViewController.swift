//
//  MapViewController.swift
//  On the Map
//
//  Created by Kbotei on 12/2/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        populateLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
    }
    
    func populateLocations(refresh: Bool = false) {
        if StudentData.locations.count > 0, !refresh {
            populateMap(locations: StudentData.locations, error: nil)
        } else {
            ParseClient.getStudentLocations(completion: populateMap(locations:error:))
        }
    }
    
    // MARK: - Completion Methods
    
    func populateMap(locations: [StudentInformation], error: Error?) {
        guard locations.count > 0 else {
            showAlert(Alerts.GeneralError, message: error?.localizedDescription)
            return
        }
        
        for location in locations {
            guard let lat = location.latitude, let lon = location.longitude,
                let firstName = location.firstName, let lastName = location.lastName else {
                continue
            }
            
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            point.title = "\(firstName) \(lastName)"
            point.subtitle = location.mediaURL ?? ""
            map.addAnnotation(point)
        }
    }
    
    // MARK: - Actions
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout { [weak self] success, error in
            if !success {
                self?.showAlert(Alerts.GeneralError, message: error?.localizedDescription)
            } else {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshLocations(_ sender: Any) {
        map.removeAnnotations(map.annotations)
        populateLocations()
    }
}

extension MapViewController: MKMapViewDelegate {
    // Use modified version of the method from the PinSample app
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Use modified method from PinSample app
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let subtitle = view.annotation?.subtitle!,
                let url = URL(string: subtitle),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
