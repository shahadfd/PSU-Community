//
//  ProfileModelView.swift
//  PSU Community
//
//  Created by MacBookPro on 12/03/1441 AH.
//  Copyright © 1441 Lamis. All rights reserved.
//

import UIKit

class ProfileModelView: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
         //test the conection vetween the view and view-model
       // view.backgroundColor = .green
        
    }
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "LogInModelView")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }

}
