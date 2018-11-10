//
//  FBUser.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/9/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import Foundation

class FBUser {
    var id: String!
    var email: String!
    var firstName: String!
    var lastName: String!
    
    init(id: String, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
