//
//  EdmodoClient.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation

fileprivate let baseURL = "https://api.edmodo.com/"
fileprivate let assignmentsBaseURL = "assignments?"
fileprivate let submissionsBaseURL = "assignment_submissions?"
fileprivate let assignmentIDurl = "assignment_id="
fileprivate let creatorIDurl = "&assignment_creator_id="
fileprivate let tokenURL = "access_token="
fileprivate let accessToken = "12e7eaf1625004b7341b6d681fa3a7c1c551b5300cf7f7f3a02010e99c84695d"

enum Endpoint {
    case getAssignments(token: String)
    case getSubmissions(assignmentID: String, creatorID: String, token: String)
    
    var url: String {
        switch self {
        case .getAssignments(let token):
            return baseURL + assignmentsBaseURL + tokenURL + token
        case .getSubmissions(let assignmentID, let creatorID, let token):
            return baseURL + submissionsBaseURL + assignmentIDurl + assignmentID + "&" + creatorIDurl + creatorID + "&" + tokenURL + token
        }
    }
}

//I have two api calls. One with no parameters and one that takes parameters
class EdmodoClient {    
    static let sharedInstance = EdmodoClient()
    
    fileprivate let session = URLSession.shared
    
    func callAPI(endPoint: Endpoint, completionHandler: @escaping ((_ assignemnts: Any) -> Void)) {

        if let url = URL(string: endPoint.url) {
            let task = session.dataTask(with: url,
                                        completionHandler: { data, response, error -> Void in
                                            if error != nil {
                                                print(error ?? "Unknown error")
                                            }
                                            else if let data = data {
                                                let jsonData = (try? JSONSerialization.jsonObject(with: data,
                                                                                                  options: JSONSerialization.ReadingOptions.allowFragments)) as? [payload]
                                                completionHandler(jsonData ?? nil)
                                                
                                            }
                                            self.session.invalidateAndCancel()
            })
            task.resume()
        }
    }
    
    func callAPI(endPoint: Endpoint, parameters: payload?, completionHandler: @escaping ((_ assignemnts: Any) -> Void)) {
        var parametersString = ""
        if let paging = parameters {
            for (key, value) in paging {
                parametersString.append("&" + key + "=" + String(describing: value))
            }
        }
        if let url = URL(string: endPoint.url + parametersString) {
            let task = session.dataTask(with: url,
                                        completionHandler: { data, response, error -> Void in
                                            if error != nil {
                                                print(error ?? "Unknown error")
                                            }
                                            else if let data = data {
                                                let jsonData = (try? JSONSerialization.jsonObject(with: data,
                                                                                                  options: JSONSerialization.ReadingOptions.allowFragments)) as? [payload]
                                                completionHandler(jsonData ?? nil)
                                                
                                            }
                                            self.session.invalidateAndCancel()
            })
            task.resume()
        }
    }
}

