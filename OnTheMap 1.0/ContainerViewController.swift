//
//  ContainerViewController.swift
//  OnTheMap 1.0
//
//  Created by M7md on 26/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

protocol Reloadable {
    func reloadLocations()
}
class ContainerViewController : UIViewController, Reloadable {
  

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentLocations()
    }
    @objc private func addLocationTapped (_ sender : Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigationViewController") as! UINavigationController
        
        present(navController ,animated: true , completion: nil)
    }
    
    @objc private func refreshLocationsTapped (_ sender:Any){
        loadStudentLocations()
    }
    
     @objc func LogoutTapped (_ sender:Any){
      let Alert = UIAlertController(title: "Logout", message: "Are you sure you wanna logout ? ", preferredStyle: .alert)
        Alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            API.deleteSession { (error) in
                guard error == nil else {
                    self.showAlert(title: "Error", message: error!)
                    return
                }
              self.dismiss(animated: true, completion: nil)
            
            }
            
        }))
    Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(Alert , animated: true , completion:  nil)
    }
    
   private func loadStudentLocations() {
        let ai = startAnActivityIndicator()
    API.Parser.getStudentLocations{ (data) in
        ai.stopAnimating()
        guard let data = data else {
            self.showAlert(title : "Error" , message : "No internet connection found" )
            return
        }
        guard data.count > 0 else {
            
            self.showAlert(title : "Error" , message : "No pins found" )
            return
        }
        SharedLocations.data = data
        self.reloadLocations()
    }
    }
    func reloadLocations() {
        fatalError()
    }
    
}
