//
//  LoginViewController.swift
//  FirebaseDemo
//
//  Created by Yucian Huang on 10/03/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.title = "Log In"
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = ""
    }
    
    // Testify
    @IBAction func login(sender: UIButton) {
        guard let emailAddress = emailTextField.text , emailAddress != "",
              let password = passwordTextField.text , password != "" else {
            
            let alertController = UIAlertController(title: "Login Failed", message: "Account/password cannot be empty, please try again.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            
            return
            
        }
        
        // Call Firebase APIs for execute the LogIn
        Auth.auth().signIn(withEmail: emailAddress, password: password, completion: { (result, error) in
            
            if let error = error {
                let alertController = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                    
                return
            }
            
            // Check if the email is testified ✔️
            guard let result = result, result.user.isEmailVerified else {
                let alertController = UIAlertController(title: "Login Error", message: "You havent confirmed your email address yet. We sent you a confirmation email when you register. Please click the verification link in the mail. If you need us to resend the mail, please try resend email.", preferredStyle: .alert)
                
                // set an okay action with a real action -> .sendEmailVerification
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                })
                
                // set an cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            



            // dismiss keyboard
            self.view.endEditing(true)
            
            // Diss miss the login view -> MainView. Button segues the viewcontroller make the ibaction valid
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
            
        })
              
    }

}
