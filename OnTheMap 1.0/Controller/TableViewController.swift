//
//  TableViewController.swift
//  OnTheMap 1.0
//
//  Created by M7md on 28/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewController :  UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    var locations : [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    
    
    @IBAction func refreshLocationsTapped (_ sender:Any){
        loadStudentLocations()
    }
    
    
    private func loadStudentLocations() {
        let ai = startAnActivityIndicator()
        API.Parser.getStudentLocations { (data) in
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
        locations = SharedLocations.data
    }
    
}



extension TableViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell" , for: indexPath) as! StudentTableViewCell
       cell.MakeChangeToCell(locations[indexPath.row])////
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let studentLocation = locations[indexPath.row]
        let mediaURL = studentLocation.mediaURL!
        let url = URL(string: mediaURL)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
