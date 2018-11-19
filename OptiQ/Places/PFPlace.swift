//
//  PFPlace.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/16/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import Foundation
import Parse

class PFPlace: PFObject, PFSubclassing {

    @NSManaged var name: String?
    @NSManaged var numbersInQueue: Array<String>?
    @NSManaged var usersInQueue: Array<String>?
    @NSManaged var avgWaitingTime: NSNumber?
    @NSManaged var currentNumber: NSNumber?

    class func parseClassName() -> String {
        return "Place"
    }

    class func nameAttribute() -> String {
        return "name"
    }

    class func numbersInQueueAttribute() -> String {
        return "numbersInQueue"
    }

    class func usersInQueueAttribute() -> String {
        return "usersInQueue"
    }

    class func averageWaitingTimeAttribute() -> String {
        return "avgWaitingTime"
    }

    class func currentNumberAttribute() -> String {
        return "currentNumber"
    }
    
    class func nextNumberAttribute() -> String {
        return "nextNumber"
    }

    class func createdAtAttribute() -> String {
        return "createdAt"
    }

    class func objectIdAttribute() -> String {
        return "objectId"
    }
}
