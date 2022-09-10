//
//  ViewController.swift
//  Foursquare Clone
//
//  Created by mehmet on 6.09.2022.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Please check your credentials.")
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                } else {
                    //TODO: Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username and/or Password should not be empty!")
        }
        
    }
    
    
    @IBAction func signUpButonTapped(_ sender: UIButton) {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            let user = PFUser()
            user.username = usernameTextField.text!
            user.password = passwordTextField.text!
            
            
            user.signUpInBackground { isSaved, error in
                if isSaved {
                    
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    self.makeAlert(titleInput: "Success", messageInput: "Account created. Please login with your credentials.")
                    
                } else {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "An error occured while connecting database. Please try again later.")
                }
            }
            
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username and/or Password should not be empty!")
        }
        
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
}


// MARK: - Add data to a db with Parse Framework
//        let parseObj = PFObject(className: "Fruits")
//
//        parseObj["name"] = "Apple"
//        parseObj["calories"] = 100
//        parseObj.saveInBackground { isSaved, error in
//            if isSaved {
//                print("Saved Successfully!")
//            } else {
//                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.present(alert, animated: true)
//            }
//        }


// MARK: - Get Data from db with Parse Framework
//        let query = PFQuery(className: "Fruits")
////        query.whereKey("name", equalTo: "Apple")
////        query.whereKey("calories", greaterThanOrEqualTo: 120)
//        query.findObjectsInBackground{ object, error in
//            if error != nil {
//                print(error?.localizedDescription)
//            } else {
//                print(object)
//            }
//        }
