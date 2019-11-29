//
//  AuthService.swift
//  PSU Community
//
//  Created by MacBookPro on 27/03/1441 AH.
//  Copyright © 1441 Lamis. All rights reserved.
//

//this class is a central authentication controller

    import Foundation
    import FirebaseAuth
    import FirebaseStorage
    import FirebaseDatabase

    class AuthService {
        
        //method to handle sign in, static to handle the session
            //onSuccess: is an escapable parameter, the user could assign a method to it to be performed when method succed, same for onError
        static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                onSuccess() //call on success method that was specified by the user
            })
            
        }
      
        //method to handle sign in, static to handle the session
            //onSuccess: is an escapable parameter, the user could assign a method to it to be performed when method succed, same for onError
        static func signUp(userFname: String, userLname: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
            
            Auth.auth().createUser(withEmail: email, password: password) { (authData: AuthDataResult?, error: Error?) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                let uid = authData!.user.uid
                let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid)
                
                storageRef.putData(imageData, metadata: nil, completion: { (_, error: Error?) in
                    if error != nil {
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                        if let profileImageUrl = url?.absoluteString {
                            self.setUserInfomation(profileImageUrl: profileImageUrl, userFname: userFname, userLname: userLname, email: email, uid: uid, onSuccess: onSuccess)
                        }

                    })
                })
            }
        }
        
        //assigning user data into his tree in the DB
        static func setUserInfomation(profileImageUrl: String, userFname: String, userLname: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
           // print("im working!!!!!!!!!!!!!!!!!!")
            let ref = Database.database().reference()
            //print(ref.description())
            let usersReference = ref.child("users")
           // print(usersReference.description())
            let newUserReference = usersReference.child(uid)
           // print(newUserReference.description())

            newUserReference.setValue(["userFname": userFname, "userFname_lowercase": userFname.lowercased(), "userLname": userLname, "userLname_lowercase": userLname.lowercased(), "email": email, "profileImageUrl": profileImageUrl])
               //       print("done!!!!!!!!!!!!!!")
            onSuccess()
        }
        
        static func updateUserInfor(userFname: String, userLname: String, email: String, imageData: Data, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
                    
            Api.User.CURRENT_USER?.updateEmail(to: email, completion: { (error) in
                if error != nil {
                    onError(error!.localizedDescription)
                }else {
                    let uid = Api.User.CURRENT_USER?.uid
                    let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_image").child(uid!)
                    storageRef.putData(imageData, metadata: nil, completion: { (_, error: Error?) in
                        if error != nil {
                            return
                        }
                        storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                            if let profileImageUrl = url?.absoluteString {
                                self.updateDatabase(profileImageUrl: profileImageUrl, userFname: userFname, userLname: userLname, email: email, onSuccess: onSuccess, onError: onError)
                            }
                            
                        })
                    })
                }
            })
            
        }
        
        static func updateDatabase(profileImageUrl: String, userFname: String, userLname: String,email: String, onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
            let dict = ["userFname": userFname, "userFname_lowercase": userFname.lowercased(), "userLname": userLname, "userLname_lowercase": userLname.lowercased(), "email": email, "profileImageUrl": profileImageUrl]
            Api.User.REF_CURRENT_USER?.updateChildValues(dict, withCompletionBlock: { (error, ref) in
                if error != nil {
                    onError(error!.localizedDescription)
                } else {
                    onSuccess()
                }
                
            })
        }
        
        static func logout(onSuccess: @escaping () -> Void, onError:  @escaping (_ errorMessage: String?) -> Void) {
            do {
                try Auth.auth().signOut()
                onSuccess()
                
            } catch let logoutError {
                onError(logoutError.localizedDescription)
            }
        }
        
    }



