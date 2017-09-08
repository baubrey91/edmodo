//
//  AssignmentViewController.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

class AssignmentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var assignments = [Assignment]()
    fileprivate var noInternet = "Please Check Your internet connection"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getAssignments),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        getAssignments()
    }
    
    func getAssignments() {
        if (Reachability.isConnectedToNetwork()) {
            activityIndicator.startAnimating()
            EdmodoClient.sharedInstance.callAPI(endPoint: .getAssignments,
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.assignments = Assignment.assignments(array: json as! [payload])
                                                        self.activityIndicator.stopAnimating()
                                                    }
            })
        }
        else {
            self.navigationItem.prompt = noInternet
        }
    }
}

extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! AssignmentTableViewCell
        cell.assignment = assignments[indexPath.row]
        return cell
    }
}
