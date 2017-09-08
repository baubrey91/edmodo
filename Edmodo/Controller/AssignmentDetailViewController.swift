//
//  AssignmentDetailViewController.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

class AssignmentDetailViewController: UIViewController {
    
    var submissions = [Submission]()
    
    override func viewDidLoad() {
        getSubmissions()
    }
    
    func getSubmissions() {
        if (Reachability.isConnectedToNetwork()) {
            //activityIndicator.startAnimating()
            EdmodoClient.sharedInstance.callAPI(endPoint: .getSubmissions(assignmentID: "24800159",
                                                                          creatorID: "73240721",
                                                                          token: "12e7eaf1625004b7341b6d681fa3a7c1c551b5300cf7f7f3a02010e99c84695d"),
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.submissions = Submission.submissions(array: json as! [payload])
                                                        //self.tableView.reloadData()
                                                        //self.activityIndicator.stopAnimating()
                                                    }
            })
        }
        else {
            self.navigationItem.prompt = "Check your internet"
        }
        
    }
}

extension AssignmentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creatorCell", for: indexPath) as! CreatorTableViewCell
        cell.submission = submissions[indexPath.row]
        return cell
    }
}
