//
//  ViewController.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/4/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import Parse
import SkyFloatingLabelTextField
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchNearbyPlaces()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.goToLoginPage()
        if PFUser.current() == nil {
            self.goToLoginPage()
        }
    }

    func fetchNearbyPlaces() {
        let query = PFQuery(className: "Place")
        query.findObjectsInBackground {
            (objects:[PFObject]?, error:Error?) -> Void in
            for object in objects! {
                if let name = object["name"] as? String {
                    print(name)
                }
            }
        }
    }

    func goToLoginPage() {
        let storyboard = UIStoryboard(name: IdentifiersUtil().loginStoryBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: IdentifiersUtil().loginViewController)
        self.present(controller, animated: true, completion: nil)
    }
}

