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
    //IBOutles
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //vars
    fileprivate var perPage = 10
    fileprivate var page = 1

    fileprivate var assignments = [Assignment]() {
        didSet {
            tableView.reloadData()
        }
    }
    //MARK:- VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getAssignments),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        setupTableView()
        getAssignments()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "assignmentDetailSegue" {
            let vc = segue.destination as! AssignmentDetailViewController
            let indexPath = tableView.indexPath(for: sender as! AssignmentTableViewCell)!
            vc.assignment = assignments[indexPath.row]
        }
    }
    
    fileprivate func setupTableView() {
        let refreshControlTable = UIRefreshControl()
        refreshControlTable.addTarget(self, action: #selector(refreshData(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControlTable, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    //MARK:- API CALLS
    func refreshData(refreshControl: UIRefreshControl) {
        if (Reachability.isConnectedToNetwork()) {
            page = 1
            perPage = 10
            EdmodoClient.sharedInstance.callAPI(endPoint: .getAssignments(token: EdmodoClient.sharedInstance.token),
                                                parameters: ["page":page, "per_page":perPage],
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.assignments = Assignment.assignments(array: json as! [payload])
                                                        self.tableView.reloadData()
                                                        refreshControl.endRefreshing()
                                                    }
            })
        }
        else {
            self.navigationItem.prompt = "Please Check Your internet connection"
        }
    }

    func getAssignments() {
        if (Reachability.isConnectedToNetwork()) {
            activityIndicator.startAnimating()
            EdmodoClient.sharedInstance.callAPI(endPoint: .getAssignments(token: EdmodoClient.sharedInstance.token),
                                                parameters: ["page":page, "per_page":perPage],
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

