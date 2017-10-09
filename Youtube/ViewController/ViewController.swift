//
//  ViewController.swift
//  Youtube
//
//  Created by Sunil Chowdary on 10/06/17.
//  Copyright © 2017 Sunil Chowdary. All rights reserved.
//
import UIKit
import GoogleSignIn
import GGLSignIn
class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var btnSignIn: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self


    }

    
    @nonobjc func signInWillDispatch(signIn: GIDSignIn!, error: Error!) {

    
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if (error == nil) {
            
            let client = user.profile.givenName
            if user.profile.hasImage {
                
                
                let picUrl = user.profile.imageURL(withDimension: 100)

                
                UserDefaults.standard.set(picUrl, forKey: "profilePic")
                
                debugPrint(picUrl!)

            }
            
            if client != nil {
                
                UserDefaults.standard.set(client, forKey: "loggedUser")
                
                self.dismiss(animated: true, completion: nil)
            }
            
            UserDefaults.standard.synchronize()
            
        } else {
            print("\(error.localizedDescription)")
        }
    }

    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }



}

