//
//  User.swift
//  Edmodo
//
//  Created by Brandon Aubrey on 9/8/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation

//hardcoded data for now
fileprivate let user: payload = ["first_name": "Brandon",
                                "last_name": "Aubrey",
                                "id": 123,
                                "avatars": "DNE"]

//I would need to create another struct for avatars so I can have the small and low image
class Creator {
    var firstName: String
    var lastName: String
    var id: Int
    var avatar: String?
    
    init(_ dic: payload) {
        self.firstName = dic["first_name"] as! String
        self.lastName = dic["last_name"] as! String
        self.id = dic["id"] as! Int ?? -1
        if let avatar = dic["avatars"] as? payload {
            self.avatar = avatar["large"] as? String
        }
    }
}

//This User class would need to be created differently with proper log in rest call,
//so I just hardcoded everything for now
class User: Creator {
    var token: String
    
    init(_ dic: payload, token: String) {
        self.token = token
        super.init(dic)
    }
    
    static let loggedIn = User(user,
                               token: "12e7eaf1625004b7341b6d681fa3a7c1c551b5300cf7f7f3a02010e99c84695d")
}
