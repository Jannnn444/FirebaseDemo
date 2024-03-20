//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Yucian Huang on 10/03/2024.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sign Up"
        nameTextField.becomeFirstResponder()
    }
    // Add the testify
    @IBAction func register(sender: UIButton) {
        guard let name = nameTextField.text, name != "",
           let emailAddress = emailTextField.text, emailAddress != "",
              let password = passwordTextField.text, password != "" 
        
        else {
            let alertController = UIAlertController(title: "Registration Error", message: "Please make sure you provide your personal datas such as name, email and password to complete the registration.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        //MARK: Register the user account at Firebase
        Auth.auth().createUser(withEmail: emailAddress, password: password, completion: { (user, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            //MARK: Storage the User Name by calling createProfileChangeRequest()
            
            if let changeRequeat = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequeat.displayName = name
                changeRequeat.commitChanges(completion: { (error) in
                
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                    
                })
            }
            // dismiss the keyboard
            self.view.endEditing(true)
            
            // fetch API check if the mail is valid
            Auth.auth().currentUser?.sendEmailVerification(completion: {(error) in
                print("Failed to send verification email")
            })
            let alertController = UIAlertController(title: "Email Need Verification", message: "We've send you a confirmation email to your email address. Please check your inbox and click the verification link that email to complete the sign up.", preferredStyle: .alert)
            let okayAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAlert)
            self.present(alertController, animated: true, completion: nil)
            
            
//            // Dismiss sign up page -> main view, button segues the viewcontroller make the ibaction valid
//            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
//                UIApplication.shared.keyWindow?.rootViewController = viewController
//                self.dismiss(animated: true, completion: nil)
//            }
            
        })
    
    }


}
