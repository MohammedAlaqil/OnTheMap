//
//  ViewController.swift
//  OnTheMap 1.0
//
//  Created by M7md on 25/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreLocation


class AddLocationViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var mediaLinkText: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touch: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
      
        guard let locations = locationText.text , let mediaLink = mediaLinkText.text , locations != "" , mediaLink != "" else {
            self.showAlert(title: "Missing information", message: "Please fill both fields")
            return
        }
        gecodeMapString(locations) { (coordinate) in
            let studentLocation = StudentLocation.init(createdAt: "" ,
                                                       firstName: nil ,
                                                       lastName: nil ,
                                                       latitude: coordinate.latitude,
                                                       longitude: coordinate.longitude,
                                                       mapString: locations ,
                                                       mediaURL : mediaLink,
                                                       objectId: "",
                                                       uniqueKey: "",
                                                       updatedAt: "" )
            
            self.performSegue(withIdentifier: "mapSegue", sender: studentLocation)
        }
   
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func gecodeMapString(_ mapString: String , completion: @escaping (_ coordinate: CLLocationCoordinate2D) -> Void ){
        let ai = startAnActivityIndicator()
        CLGeocoder().geocodeAddressString(mapString){(marks , error ) in
            ai.stopAnimating()
            guard error == nil else {
                if let marks = marks {
                print("MARKS :", marks)
                }
                print("ERROR:", error!)
                self.showAlert(title: "Error", message: "couldn't geocode your location")
                return
            }
            let coordinate = marks!.first!.location!.coordinate
            completion(coordinate)
 
        }
      
    }
    
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" , let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
   
    
    }


