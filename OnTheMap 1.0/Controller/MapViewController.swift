//
//   MapViewController.swift
//  OnTheMap 1.0
//
//  Created by M7md on 26/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//


import UIKit
import MapKit

class MapViewController : UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isZoomEnabled = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadStudentLocations()
    }

    
    func updatePins() {
        
        let locations = SharedLocations.data
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            guard let locationLat = location.latitude , let locationLong = location.longitude else { continue }
            let lat = CLLocationDegrees(locationLat)
            let long = CLLocationDegrees(locationLong)
            
            let cordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = cordinate
            annotation.title = "\(first ?? "") \(last ?? "") "
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
        }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
    }
    
    

    
    
    @IBAction func refreshLocationsTapped (_ sender:Any){
        loadStudentLocations()
    }
    
    @IBAction func LogoutAction(_ sender: Any) {
        let Alert = UIAlertController(title: "Logout", message: "Are you sure you wanna logout ? ", preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            API.deleteSession { (error) in
                guard error == nil else {
                    self.showAlert(title: "Error", message: error! as! String)
                    return
                }
                
                
            }
          self.dismiss(animated: true, completion: nil)
            
        }))
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(Alert , animated: true , completion:  nil)
    }
    
    
    
    private func loadStudentLocations() {
        let ai = startAnActivityIndicator()
        API.Parser.getStudentLocations{ (locations) in
            ai.stopAnimating()
            guard let data = locations else {
                self.showAlert(title : "Error" , message : "No internet connection found" )
                return
            }
            guard data.count > 0 else {
                
                self.showAlert(title : "Error" , message : "No pins found" )
                return
            }
            SharedLocations.data = locations!
            self.reloadLocations()
        }
    }
    
    func reloadLocations() {
        updatePins()
    }
    
    
    
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
