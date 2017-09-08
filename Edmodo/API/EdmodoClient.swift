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
fileprivate let tokenURL = "access_token=12e7eaf1625004b7341b6d681fa3a7c1c"

enum Endpoint {
    case getAssignments
    case getSubmissions
    
    var url: String {
        switch self {
        case .getAssignments:
            return baseURL + assignmentsBaseURL + tokenURL
        case .getSubmissions:
            return baseURL + submissionsBaseURL + tokenURL
        }
    }
}

class EdmodoClient {
    
    static let sharedInstance = EdmodoClient()
    fileprivate let session = URLSession.shared
    
    func callAPI(endPoint: Endpoint, completionHandler: @escaping ((_ assignemnts: Any) -> Void)) {
        if let url = URL(string: endPoint.url) {
            let task = session.dataTask(with: url,
                                        completionHandler: { data, response, error -> Void in
                                            if error != nil {
                                                print(error)
                                            }
                                            if data != nil {
                                                let jsonData = (try? JSONSerialization.jsonObject(with: data!,
                                                                                                  options: JSONSerialization.ReadingOptions.allowFragments)) as? payload
                                                if let json = jsonData?[""] as? [payload] {
                                                    completionHandler(json as Any)
                                                }
                                            }
                                            self.session.invalidateAndCancel()
            })
            task.resume()
        }
    }
}
