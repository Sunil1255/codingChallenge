//
//  AppDelegate.swift
//  Youtube
//
//  Created by Sunil Chowdary on 10/06/17.
//  Copyright © 2017 Sunil Chowdary. All rights reserved.
//

import UIKit
import GoogleSignIn



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)

      //  assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        
        
        return true
    }

    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
      
    }
    
   

}

