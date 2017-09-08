//
//  Submission.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation

class Submission {
    var content: String
    var submittedAt: String
    var creator: Creator
    
    init(_ jsonDic: payload) {
        self.content = jsonDic["content"] as! String
        self.submittedAt = jsonDic["submitted_at"] as! String
        self.creator = Creator(jsonDic["creator"] as! payload)
    }
    
    class func submissions(array: [payload]) -> [Submission] {
        var submissions = [Submission]()
        for jsonDic in array {
            let submission = Submission(jsonDic)
            submissions.append(submission)
        }
        return submissions
    }
}

class Creator {
    var firstName: String
    var lastName: String
    var id: Int
    var avatar: String?
    
    init(_ dic: payload) {
        self.firstName = dic["first_name"] as! String
        self.lastName = dic["last_name"] as! String
        self.id = dic["id"] as! Int
        if let avatar = dic["avatars"] as? payload {
            self.avatar = avatar["large"] as? String
        }
    }
}
