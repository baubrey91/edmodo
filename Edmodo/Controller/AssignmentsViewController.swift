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
    
    fileprivate var assignments = [Assignment]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getAssignments),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        getAssignments()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "assignmentDetailSegue" {
            let vc = segue.destination as! AssignmentDetailViewController
            let indexPath = tableView.indexPath(for: sender as! AssignmentTableViewCell)!
            vc.assignment = assignments[indexPath.row]
        }
    }
    
    func getAssignments() {
        if (Reachability.isConnectedToNetwork()) {
            activityIndicator.startAnimating()
            EdmodoClient.sharedInstance.callAPI(endPoint: .getAssignments(token: EdmodoClient.sharedInstance.token),
                                                parameters: ["page":1, "per_page":10],
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.assignments = Assignment.assignments(array: json as! [payload])
                                                        self.tableView.reloadData()
                                                        self.activityIndicator.stopAnimating()
                                                    }
            })
        }
        else {
            self.navigationItem.prompt = "Please Check Your internet connection"
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

