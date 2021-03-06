//
//  Assignment.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation

class Assignment  {
    var title: String
    var description: String
    var dueAt: String
    var id: Int
    var creator: Creator
    
    init(_ jsonDic: payload) {
        self.title = jsonDic["title"] as! String
        self.description = jsonDic["description"] as! String
        self.dueAt = jsonDic["due_at"] as! String
        self.id = jsonDic["id"] as! Int
        self.creator = Creator(jsonDic["creator"] as! payload)
    }
    
    //returns array of assignments
    class func assignments(array: [payload]) -> [Assignment] {
        var assignments = [Assignment]()
        for jsonDic in array {
            let assignment = Assignment(jsonDic)
            assignments.append(assignment)
        }
        return assignments
    }
}
