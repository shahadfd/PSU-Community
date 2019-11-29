//
//  SignUpViewController.swift
//  PSU Community
//
//  Created by MacBookPro on 12/03/1441 AH.
//  Copyright © 1441 Lamis. All rights reserved.
//

import UIKit
class RegisterModelView: UIViewController {

//Connections and global elements
      
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    //optional image var , to be used in moving img to db
    var selectedImage: UIImage?
  
    
//loading view, a method to render the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Editing the shape of the profile image uploader
        profileImage.layer.cornerRadius = 40 //rounding factor = 40
        profileImage.clipsToBounds = true
        
        //Select image from library by taping on img placeholder
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        signUpButton.isEnabled = false
        handleTextField()
    }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        firstNameTextfield.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        lastNameTextfield.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextfield.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextfield.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    //this fuction will check all text fields, if all not empty it will allow the button to be clicked, otherwise it will dissable the button
    @objc func textFieldDidChange() {
    guard let userFname = firstNameTextfield.text, !userFname.isEmpty,let userLname = lastNameTextfield.text, !userLname.isEmpty, let email = emailTextfield.text, !email.isEmpty,
        let password = passwordTextfield.text, !password.isEmpty else {
            //button is disabled cause one or more of the text fields are empty
            signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
            signUpButton.isEnabled = false
            return //escape
        } //all fields are filed -> enable button
        signUpButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        signUpButton.isEnabled = true
    }
        
    //view selected img in the same page
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    //return to sign in page
    @IBAction func dismiss_onClick(_ sender: Any) {
         dismiss(animated: true, completion: nil)
     }
    
    
    
/*this function will be trigered when signup button is touched in upinside way to creat the user and send his info to Firebase NOSQL Databse */
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        
            view.endEditing(true)
            ProgressHUD.show("Waiting...", interaction: false)
            
            if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) { //if img is selected send data to db in jpeg format
                AuthService.signUp(userFname: firstNameTextfield.text!,userLname: lastNameTextfield.text!, email: emailTextfield.text!, password: passwordTextfield.text!, imageData: imageData, onSuccess: {
                    //to be shown when data is passed to db successfuly
                    ProgressHUD.showSuccess("Success") //green tic sign
                    self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil) //change view to timeline
                }, onError: { (errorString) in
                    ProgressHUD.showError(errorString!) //show red cross
                })
            } else { //if img is nil show err msg
                 ProgressHUD.showError("Profile Image can't be empty")
            }
  
        }
    } //end of class
    
    
// extension to this class = extra methods
//extensions are used to increse the cohesion and to make the code more readable by taking out minor functionalities
    //this extension handles the chosen profile img before sending it to firebase storage and database

    extension RegisterModelView: UIImagePickerControllerDelegate, UINavigationControllerDelegate { //implementing protocols that enable recieving imgs from library
        
        //implementing image picker function that was inhereted from the UIImagePickerControllerDelegate protocol
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //assign the selected photo to the img element to change the placeholder
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        //when picked, dissmiss the picker
        dismiss(animated: true, completion: nil)
    }
    

}
