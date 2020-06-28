//
//  ConfirmLocationViewController.swift
//  OnTheMap 1.0
//
//  Created by M7md on 28/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location : StudentLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        mapView.isZoomEnabled = true
        mapView.delegate = self
         update()
    }
    
    
    func update (){
        guard let locations = location else { return }
        let lat = CLLocationDegrees(locations.latitude!)
        let long = CLLocationDegrees(locations.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locations.mapString
        
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    
    
    @IBAction func finshButtonPressed(_ sender: Any) {
     
        API.Parser.postLocation(self.location!) { (error) in
            guard error == nil else {
                self.showAlert(title: "Error", message: error!)
                return
            }
           self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
       
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



    extension ConfirmLocationViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
        
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle ?? nil , let url = URL(string: toOpen) , app.canOpenURL(url) {
                app.open(url, options: [:] , completionHandler: nil)
                
            }
            else {
                self.showAlert(title: "Error", message: "Can't open URL")
            }
        }
    }
    }
    
        
    

