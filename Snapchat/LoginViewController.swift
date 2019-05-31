//
//  LoginViewController.swift
//  Snapchat
//
//  Created by Mahieu Bayon on 11/10/2018.
//  Copyright © 2018 M4m0ut. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    var signupMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
               
                if signupMode {
                    // Sign Up
                    
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.presentAlert(message: error.localizedDescription)
                        } else {
                            if let user = user {
                                Database.database().reference().child("users").child(user.user.uid).child("email").setValue(user.user.email!)
                                self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            }
                        }
                    })
                    
                } else {
                    // Log In
                    
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.presentAlert(message: error.localizedDescription)
                            
                        } else {
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    })
                }
            }
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchTapped(_ sender: Any) {
        if signupMode {
            // Switch to Log In
            signupMode = false
            loginButton.setTitle("Log In", for: .normal)
            switchButton.setTitle("Switch to Sign Up", for: .normal)
        } else {
            // Switch to Sign Up
            signupMode = true
            loginButton.setTitle("Sign Up", for: .normal)
            switchButton.setTitle("Switch to Log In", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

