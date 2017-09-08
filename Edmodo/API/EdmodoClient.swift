//
//  EdmodoClient.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

class EdmodoClient {
    
    static let sharedInstance = EdmodoClient()
    
    fileprivate let baseURL = "https://api.edmodo.com/"
    fileprivate let assigmentsURL = "assignments?"
    fileprivate let submissionsURL = "assignment_submissions?"
    fileprivate let tokenURL = "access_token=12e7eaf1625004b7341b6d681fa3a7c1c"
    fileprivate let session = URLSession.shared
    
    //fileprivate let getAssignemntsURL = baseURL + assigmentsURL + tokenURL
    //fileprivate let url = "https://api.edmodo.com/assignments?access_token=12e7eaf1625004b7341b6d681fa3a7c1c"
    //fileprivate let url2 = "https://api.edmodo.com/assignment_submissions?assignment_id=ASSIGNMENT_ID&assign"
    
    fileprivate func getAssignemntsURL() -> URL? {
        let getAssignemntsURL = baseURL + assigmentsURL + tokenURL
        guard canOpenURL(string: getAssignemntsURL) else { return nil }
        return URL(string: getAssignemntsURL)!
    }
    
    fileprivate func getSubmissionsURL() -> URL? {
        let getSubmissionURL = baseURL + submissionsURL + tokenURL
        guard canOpenURL(string: getSubmissionURL) else { return nil }
        return URL(string: getSubmissionURL)!
    }
    
    func getAssignments(completionHandler: @escaping ((_ assignemnts: Any) -> Void)) {
        
        if let url = getAssignemntsURL() {
            let task = session.dataTask(with: url,
                                        completionHandler: { data, respons, error -> Void in
                                            if error != nil {
                                                completionHandler(error as Any)
                                            }
                                            
                                            if data != nil {
                                                let jsonData = (try? JSONSerialization.jsonObject(with: data!,
                                                                                                  options: JSONSerialization.ReadingOptions.allowFragments)) as? payload
                                                if let dictionaries = jsonData?[""] as? [payload] {
                                                    completionHandler(Assignment.assignments(array: dictionaries) as Any)
                                                }
                                            }
                                            self.session.invalidateAndCancel()
            })
            task.resume()
        }
    }

    func getSubmissions(completionHandler: @escaping ((_ submissions: Any) -> Void)) {
        
        if let url = getAssignemntsURL() {
            let task = session.dataTask(with: url,
                                        completionHandler: { data, respons, error -> Void in
                                            if error != nil {
                                                completionHandler(error as Any)
                                            }
                                            
                                            if data != nil {
                                                let jsonData = (try? JSONSerialization.jsonObject(with: data!,
                                                                                                  options: JSONSerialization.ReadingOptions.allowFragments)) as? payload
                                                if let dictionaries = jsonData?[""] as? [payload] {
                                                    completionHandler(Submission.submissions(array: dictionaries) as Any)
                                                }
                                            }
                                            self.session.invalidateAndCancel()
            })
            task.resume()
        }
    }

    fileprivate func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
}
