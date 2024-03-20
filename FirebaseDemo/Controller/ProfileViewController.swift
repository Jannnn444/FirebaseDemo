//
//  ProfileViewController.swift
//  FirebaseDemo
//
//  Created by Yucian Huang on 10/03/2024.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Profile"
        
        // We fetch the username data form API
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            
        } catch {
            let alertController = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
            let okayaction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayaction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
            
        // Back to the welcome view, logout button segues to welcome view valid the IBAction
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
