//
//  LoginViewController.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/4/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Lottie
import Parse
import SkyFloatingLabelTextField
import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!

    let fbLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = [FBPermissionsUtil.email, FBPermissionsUtil.friends, FBPermissionsUtil.profilePic, FBPermissionsUtil.birthday]
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordField.isSecureTextEntry = true
        self.addFbLoginButton()
        self.configureLoginButton()
        self.addAnimationView()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        // login is successful
        self.fetchMyInfo()
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }

    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    func fetchMyInfo() {
        let parameters = ["fields": "\(FBPermissionsUtil.email), \(FBPermissionsUtil.firstName), \(FBPermissionsUtil.lastName), \(FBPermissionsUtil.gender)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{ (connection, result, error) in
            if let data = result as? [String: Any] {
                if let firstName = data[FBPermissionsUtil.firstName] as? String {
                    if let lastName = data[FBPermissionsUtil.lastName] as? String {
                        if let id = data[FBPermissionsUtil.id] as? String {
                            if let email = data[FBPermissionsUtil.email] as? String {
                                self.signUpWithParse(id: id, firstName: firstName, lastName: lastName, email: email)
                            }else {
                                // TODO: Check if email always received when user logins with facebook
                                self.signUpWithParse(id: id, firstName: firstName, lastName: lastName, email: "\(id)@hotmail.com")
                            }
                            return
                        }
                    }
                }
            }
        }
    }

    func signUpWithParse(id: String, firstName: String, lastName: String, email: String) {
        let newUser = PFUser()
        newUser.username = id
        newUser.password = EncryptionHelper.hash(string: id)
        newUser.email = email
        newUser[UserUtil.firstName] = firstName
        newUser[UserUtil.lastName] = lastName
        
        newUser.signUpInBackground(block: { (succeed, error) -> Void in  //closure works in parallel
            if ((error) != nil) {
                self.logInWithParse(id: id)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    func logInWithParse(id: String) {
        PFUser.logInWithUsername(inBackground: id, password: EncryptionHelper.hash(string: id), block: { (user, error) -> Void in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    func addFbLoginButton() {
        self.fbLoginButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y * 1.5)
        self.fbLoginButton.delegate = self
        self.view.addSubview(self.fbLoginButton)
    }

    func configureLoginButton() {
        self.loginButton.layer.borderWidth = 1.5
        self.loginButton.layer.borderColor = UIColor.white.cgColor
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.layer.masksToBounds = true
    }

    func addAnimationView() {
        let animationView = LOTAnimationView(name: "gradient_animated_background.json")
        animationView.frame = self.view.frame
        animationView.loopAnimation = true
        self.view.addSubview(animationView)
        self.view.sendSubviewToBack(animationView)
        animationView.play()

        let logoAnimationView = LOTAnimationView(name: "funky_chicken.json")
        logoAnimationView.frame = CGRect(x: self.view.center.x - 100, y: 100, width: 200, height: 150)
        logoAnimationView.loopAnimation = true
        self.view.addSubview(logoAnimationView)
        //self.view.sendSubviewToBack(logoAnimationView)
        logoAnimationView.play()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
}
