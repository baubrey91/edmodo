//
//  AssignmentDetail.swift
//  Edmodo
//
//  Created by Brandon Aubrey on 9/16/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation

class AssignmentDetailViewModel {
    
    var submissions = [Submission]()
    
    fileprivate var page = 1
    fileprivate var perPage = 10
    fileprivate var id: String
    fileprivate var creatorId: String
    
    init(id: String, creatorId: String) {
        self.id = id
        self.creatorId = creatorId
    }
    
    weak var delegate: ViewModelDelegate?
    
    func getSubmissions(dataCall: dataCall) {
        if dataCall == .append {
            perPage += 10
        } else {
            perPage = 10
            page = 1
        }
        EdmodoClient.sharedInstance.callAPI(endPoint: .getSubmissions(assignmentID: id,
                                                                      creatorID: creatorId,
                                                                      token: User.loggedIn.token),
                                            parameters: ["page": page, "per_page": perPage],
                                            completionHandler: {
                                                json in DispatchQueue.main.async {
                                                    self.submissions = Submission.submissions(array: json as! [payload])
                                                    switch dataCall {
                                                    case .append:
                                                        self.delegate?.appendAssignments()
                                                    case .load:
                                                        self.delegate?.loadAssignments()
                                                    case .refresh:
                                                        self.delegate?.resfreshAssignments()
                                                    }
                                                }
        })
    }
}
