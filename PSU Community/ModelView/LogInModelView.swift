//
//  SignInViewController.swift
//  PSU Community
//
//  Created by MacBookPro on 12/03/1441 AH.
//  Copyright © 1441 Lamis. All rights reserved.
//

import UIKit
import FirebaseDatabase
class LogInModelView: UIViewController {

    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Clear color of the input fields
        emailTextField.backgroundColor = UIColor.clear
        passwordTextField.backgroundColor = UIColor.clear
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        signInButton.isEnabled = false
        handleTextField()
        
        
    
    }
    
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
     }
     
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         if Api.User.CURRENT_USER != nil {
        self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil )
        }
    }
     
     func handleTextField() {
         emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
         passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
         
     }
     
     @objc func textFieldDidChange() {
         guard let email = emailTextField.text, !email.isEmpty,
             let password = passwordTextField.text, !password.isEmpty else {
                 signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                 signInButton.isEnabled = false
                 return
         }
         
         signInButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
         signInButton.isEnabled = true
     }
     
     @IBAction func signInButton_TouchUpInside(_ sender: Any) {
         view.endEditing(true)
         ProgressHUD.show("Waiting...", interaction: false)
         AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
             ProgressHUD.showSuccess("Success")
             self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
             
         }, onError: { error in
             ProgressHUD.showError(error!)
         })
     }
     
     
 }



