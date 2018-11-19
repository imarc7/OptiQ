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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var places: [Place] = []
    var selectedPlace: Place!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchNearbyPlaces()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.checkIfUserLoggedIn()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func fetchNearbyPlaces() {
        let query = PFQuery(className: PFPlace.parseClassName())
        query.findObjectsInBackground {
            (objects:[PFObject]?, error:Error?) -> Void in
            for object in objects! {
                if let name = object[PFPlace.nameAttribute()] as? String {
                    self.places.append(Place(id: object.objectId!, name: name))
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: IdentifiersUtil.placeTableViewCell) as! PlaceTableViewCell
        cell.placeNameLabel.text = self.places[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlace = self.places[indexPath.row]
        self.performSegue(withIdentifier: IdentifiersUtil.fromPlaceViewToPlaceDetail, sender: self)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifiersUtil.fromPlaceViewToPlaceDetail {
            let destinationViewController = segue.destination as! PlaceDetailViewController
            destinationViewController.placeId = self.selectedPlace.id
        }
    }

    func checkIfUserLoggedIn() {
        if PFUser.current() == nil {
            self.goToLoginPage()
        }
    }

    func goToLoginPage() {
        let storyboard = UIStoryboard(name: IdentifiersUtil.loginStoryBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: IdentifiersUtil.loginViewController)
        self.present(controller, animated: true, completion: nil)
    }
}

