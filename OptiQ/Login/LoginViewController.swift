//
//  LoginViewController.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/4/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = [FBPermissionsUtil().email, FBPermissionsUtil().friends, FBPermissionsUtil().profilePic, FBPermissionsUtil().birthday]
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("login presented")
        self.addLoginButton()
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("login successful")
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }

    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    func addLoginButton() {
        self.loginButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        self.loginButton.delegate = self
        self.view.addSubview(self.loginButton)
    }
}
