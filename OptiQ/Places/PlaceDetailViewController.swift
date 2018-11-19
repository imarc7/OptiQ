//
//  PlaceDetailViewController.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/16/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//
import Parse
import ParseLiveQuery
import UIKit

let placeQueueLiveQueryClient = ParseLiveQuery.Client()

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var waitInLineButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var numberOfPeopleBeforeMeInLineLabel: UILabel!
    @IBOutlet weak var waitinTimeLabel: UILabel!

    var placeId: String = ""
    var canWaitInLine: Bool = false
    var currentNumber: Int = 0
    var myNumber: Int = -1
    fileprivate var subscription: Subscription<PFPlace>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePlaceImageView()
        self.configureWaitInLineButton()
        self.queryWaitingLine()
        self.listenToLiveQueueUpdates()
    }

    func queryWaitingLine() {
        let query = PFQuery(className: PFPlace.parseClassName())
        query.whereKey(PFPlace.objectIdAttribute(), equalTo: self.placeId)
        query.findObjectsInBackground {
            (objects:[PFObject]?, error:Error?) -> Void in
            for object in objects! {
                if let numbersInQueue = object[PFPlace.numbersInQueueAttribute()] as? [String] {
                    if let usersInQueue = object[PFPlace.usersInQueueAttribute()] as? [String] {
                        if let averageWaitingTime = object[PFPlace.averageWaitingTimeAttribute()] as? Int {
                            if let currentNumber = object[PFPlace.currentNumberAttribute()] as? Int {
                                if usersInQueue.contains((PFUser.current()?.username)!) {
                                    self.canWaitInLine = false
                                    self.waitInLineButton.setTitle("In Line", for: .normal)
                                    self.currentNumber = currentNumber
                                    let myPositionInLine: Int = self.determineMyPositionInLine(usersInQueue: usersInQueue)
                                    if currentNumber != 0 {
                                        self.numberOfPeopleBeforeMeInLineLabel.text = "\(myPositionInLine)"
                                        self.waitinTimeLabel.text = "\(averageWaitingTime * (myPositionInLine + 1)) seconds"
                                    }else {
                                        self.numberOfPeopleBeforeMeInLineLabel.text = "\(myPositionInLine-1)"
                                        self.waitinTimeLabel.text = "Instant Access"
                                    }
                                }else{
                                    self.numberOfPeopleBeforeMeInLineLabel.text = "\(numbersInQueue.count)"
                                    self.canWaitInLine = true
                                    self.waitInLineButton.setTitle("Wait in Line", for: .normal)
                                    if currentNumber != 0 {
                                        self.waitinTimeLabel.text = "\(averageWaitingTime * (usersInQueue.count + 1)) seconds"
                                    }else {
                                        self.waitinTimeLabel.text = "Instant Access"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func listenToLiveQueueUpdates() {
        var myQuery: PFQuery<PFPlace> {
            return (PFPlace.query()?.whereKey(PFPlace.objectIdAttribute(), equalTo: self.placeId).order(byAscending: PFPlace.createdAtAttribute()))! as! PFQuery<PFPlace>
        }
        self.subscription = placeQueueLiveQueryClient
            .subscribe(myQuery)
            .handle(Event.updated) { _, message in
                if message.usersInQueue!.contains((PFUser.current()?.username)!) {
                    let myPositionInLine: Int = self.determineMyPositionInLine(usersInQueue: message.usersInQueue!)
                    DispatchQueue.main.async {
                        self.numberOfPeopleBeforeMeInLineLabel.text = "\(myPositionInLine-1)"
                        self.waitinTimeLabel.text = "\(Int(truncating: message.avgWaitingTime!) * (myPositionInLine + 1)) seconds"
                    }
                }else{
                    DispatchQueue.main.async {
                        self.numberOfPeopleBeforeMeInLineLabel.text = "\(String(describing: message.numbersInQueue!.count))"
                        self.waitinTimeLabel.text = "\(Int(truncating: message.avgWaitingTime!) * (message.usersInQueue!.count + 1)) seconds"
                        if message.currentNumber! as! Int == self.myNumber {
                            self.waitInLineButton.setTitle("Your turn!", for: .normal)
                        }else {
                            self.canWaitInLine = true
                            self.waitInLineButton.setTitle("Wait In Line", for: .normal)
                        }
                    }
                }
        }
    }

    func configureWaitInLineButton() {
        self.waitInLineButton.layer.borderWidth = 7
        self.waitInLineButton.layer.borderColor = UIColor(red: 0/255, green: 145/255, blue: 255/255, alpha: 1.0).cgColor
        self.waitInLineButton.layer.cornerRadius = self.waitInLineButton.frame.width/2
        self.waitInLineButton.layer.masksToBounds = true
    }

    func configurePlaceImageView() {
        self.placeImageView.layer.cornerRadius = 7
        self.placeImageView.layer.masksToBounds = true
    }

    func determineMyPositionInLine(usersInQueue: [String]) -> Int {
        for i in 0..<usersInQueue.count {
            if usersInQueue[i] == (PFUser.current()?.username)! {
                return i+1
            }
        }
        return 0
    }

    @IBAction func waitInLineButtonTapped(_ sender: Any) {
        if self.canWaitInLine {
            self.canWaitInLine = false
            let query = PFQuery(className: PFPlace.parseClassName())
            query.whereKey(PFPlace.objectIdAttribute(), equalTo: self.placeId)
            query.limit = 1
            query.findObjectsInBackground {
                (objects:[PFObject]?, error:Error?) -> Void in
                for object in objects! {
                    if let nextNumber  = object[PFPlace.nextNumberAttribute()] as? Int {
                        self.myNumber = nextNumber
                        object.addUniqueObject("\(nextNumber)", forKey: PFPlace.numbersInQueueAttribute())
                        object.addUniqueObject((PFUser.current()?.username)!, forKey: PFPlace.usersInQueueAttribute())
                        object.incrementKey(PFPlace.nextNumberAttribute())
                        object.saveInBackground(block: { (success: Bool, error: Error?) -> Void in
                            self.waitInLineButton.setTitle("In Line", for: .normal)
                            return
                        })
                    }
                }
            }
        }
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
