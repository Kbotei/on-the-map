//
//  LocationMapViewController.swift
//  On the Map
//
//  Created by Kbotei on 12/5/18.
//  Copyright © 2018 Kbotei. All rights reserved.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController {
    
    var location: String?
    var link: String?
    
    var coordinates: CLLocationCoordinate2D?

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Search for location using method found at
        // https://stackoverflow.com/questions/49760516/how-to-search-for-location-and-display-results-with-mapkit-swift-4
        
        guard let location = self.location else {
            showAlert(Alerts.GeneralError, message: Alerts.LocationEmptyMessage)
            return
        }
        
        activity.isHidden = false
        activity.hidesWhenStopped = true
        activity.startAnimating()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            self?.activity.stopAnimating()
            
            guard let response = response, let item = response.mapItems.first else {
                self?.showAlert(Alerts.GeneralError, message: Alerts.LocationSearchMessage)
                return
            }
            
            let point = MKPointAnnotation()
            point.coordinate = item.placemark.coordinate
            point.title = item.placemark.title
            self?.map.addAnnotation(point)
            
            self?.coordinates = item.placemark.coordinate
            
            // Use zoom method located found at
            // https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
            
            let zoomedRegion = MKCoordinateRegion(center: item.placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.50, longitudeDelta: 0.50))
            self?.map.setRegion(zoomedRegion, animated: true)
        }
        
    }
    
    @IBAction func finish(_ sender: Any) {
        if let coordinates = self.coordinates {
            // Apparently it is rather easy to conver a CLLocationDegrees to a double. https://stackoverflow.com/questions/30211946/change-cllocationdegrees-into-a-double-nsnumber-to-save-in-core-data-swift
            let studentInformation = StudentInformation(objectId: nil,
                                                        uniqueKey: UdacityClient.user?.account.key,
                                                        firstName: "Sherlock",
                                                        lastName: "Holmes",
                                                        mapString: location,
                                                        mediaURL: link ?? "",
                                                        latitude: Double(coordinates.latitude),
                                                        longitude: Double(coordinates.longitude),
                                                        createdAt: nil,
                                                        updatedAt: nil,
                                                        udacity: nil)
            
            ParseClient.createStudentLocation(location: studentInformation) { [weak self] success, error in
                if success {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    self?.showAlert(Alerts.GeneralError, message: Alerts.LocationSaveMessage)
                }
            }
        }
    }

}
