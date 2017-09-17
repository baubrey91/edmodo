//
//  AssignmentsViewModel.swift
//  Edmodo
//
//  Created by Brandon Aubrey on 9/16/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelDelegate: class {
    func loadAssignments()
    func resfreshAssignments()
    func appendAssignments()
}

enum dataCall {
    case load
    case append
    case refresh
}

class AssignmentsViewModel {
    
    fileprivate var perPage = 10
    fileprivate var page = 1
    var assignments = [Assignment]()
    
    weak var delegate: ViewModelDelegate?
    
    func getAssignments(dataCall: dataCall) {
        if dataCall == .append {
            perPage += 10
        } else {
            page = 1
            perPage = 10
        }
        
        EdmodoClient.sharedInstance.callAPI(endPoint: .getAssignments(token: User.loggedIn.token),
                                            parameters: ["page":page, "per_page":perPage],
                                            completionHandler: {
                                                json in DispatchQueue.main.async {
                                                    self.assignments = Assignment.assignments(array: json as! [payload])
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
