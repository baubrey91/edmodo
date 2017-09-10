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
    
    //returns array of submissions
    class func submissions(array: [payload]) -> [Submission] {
        var submissions = [Submission]()
        for jsonDic in array {
            let submission = Submission(jsonDic)
            submissions.append(submission)
        }
        return submissions
    }
}
