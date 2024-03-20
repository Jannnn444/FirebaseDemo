//
//  ResetPasswordViewController.swift
//  FirebaseDemo
//
//  Created by Yucian Huang on 10/03/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forgot Password"
        emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func resetPassword(sender: UIButton) {
        
      // Tesstify if the email is written correctly but cannot login success, pop up alert password forget reminder
        guard let emailAddress = emailTextField.text,
              emailAddress != "" else {
            let alertController = UIAlertController(title: "Input Error", message: "Please provide your email address for password reset", preferredStyle: .alert)
            let okayAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAlert)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // send the password-reset email
        Auth.auth().sendPasswordReset(withEmail: emailAddress, completion: {(error) in
        
            // success find the email in firebase || failed
            let title = (error == nil) ? "Password Reset Follow Me" : "Password Reset Error"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your mail box for reset password." : error?.localizedDescription
            
            let alertControler = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
            
                // dissmiss keyboard
                if error == nil {
                    self.view.endEditing(true)
                    
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
                
            })
            alertControler.addAction(okayAction)
            self.present(alertControler, animated: true, completion: nil)
            
        })
        
        
    }
    
    
}
