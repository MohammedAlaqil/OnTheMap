//
//  LoginViewController.swift
//  OnTheMap 1.0
//
//  Created by M7md on 25/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//


import UIKit

class LoginViewController : UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        email.delegate = self
        password.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        email.text = nil
        password.text = nil
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let ai = startAnActivityIndicator()
        
        guard let email = email.text , let password = password.text , !email.isEmpty  , !password.isEmpty else {
        self.showAlert(title: "Warning", message: "you should fill both fields")
            ai.stopAnimating()
        return
        }
        API.postSession(userName: email, password: password, completion: { (error) in
         guard error == nil else {
         self.showAlert(title: "Error", message: error!)
         ai.stopAnimating()
         return
         }
         
         DispatchQueue.main.async {
         self.performSegue(withIdentifier: "Login", sender: nil)
         ai.stopAnimating()
         }
         })
    
    }
    
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
     if let url = url {
        UIApplication.shared.open(url , options: [:], completionHandler: nil)
        }
      }
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touch: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}
