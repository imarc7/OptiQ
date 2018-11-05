//
//  ViewController.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/4/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testServer()
    }

    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: IdentifiersUtil().loginStoryBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: IdentifiersUtil().loginViewController)
        self.present(controller, animated: true, completion: nil)
    }

    func testServer() {
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

}

