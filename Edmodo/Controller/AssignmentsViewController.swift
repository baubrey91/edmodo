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
    fileprivate var isMoreDataLoading = false
    fileprivate var loadingMoreView: InfiniteScrollActivityView?
    var assignments = [Assignment]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK:- VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureInfinteScroll()
        getAssignments(append: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "assignmentDetailSegue" {
            let vc = segue.destination as! AssignmentDetailViewController
            let indexPath = tableView.indexPath(for: sender as! AssignmentTableViewCell)!
            vc.assignment = assignments[indexPath.row]
        } else if segue.identifier == "newAssignmentSegue" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! NewAssignmentViewController
            vc.delegate = self
        }
    }
    
    fileprivate func setupTableView() {
        let refreshControlTable = UIRefreshControl()
        refreshControlTable.addTarget(self, action: #selector(refreshData(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControlTable, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    fileprivate func configureInfinteScroll() {
        //set up infinte scroll
        let frame = CGRect(x: 0,
                           y: tableView.contentSize.height,
                           width: tableView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView?.backgroundColor = UIColor.clear
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }

    
    //MARK:- API CALLS
    func refreshData(refreshControl: UIRefreshControl) {
        if (Reachability.isConnectedToNetwork()) {
            page = 1
            perPage = 10
            EdmodoClient.sharedInstance.callAPI(endPoint: .getAssignments(token: User.loggedIn.token),
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

    func getAssignments(append: Bool) {
        if (Reachability.isConnectedToNetwork()) {
            if append {
                perPage += 10
            } else {
                page = 1
                perPage = 10
                activityIndicator.startAnimating()
            }
            
            EdmodoClient.sharedInstance.callAPI(endPoint: .getAssignments(token: User.loggedIn.token),
                                                parameters: ["page":page, "per_page":perPage],
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.assignments = Assignment.assignments(array: json as! [payload])
                                                        self.tableView.reloadData()
                                                        if append {
                                                            self.loadingMoreView?.stopAnimating()
                                                        } else {
                                                        self.activityIndicator.stopAnimating()
                                                        }
                                                    }
            })
        }
        else {
            self.navigationItem.prompt = "Please Check Your internet connection"
        }
    }
}

//MARK:- TablbleView Delegate
extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! AssignmentTableViewCell
        cell.assignment = assignments[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //infinite scroll
        if !isMoreDataLoading {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height,
                                   width: tableView.bounds.size.width,
                                   height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                getAssignments(append: true)
            }
        }
    }
}

//MARK:- new assignment protocol
extension AssignmentsViewController: newAssignmentDelegate {
    func newAssignment(newAssignmentViewController: NewAssignmentViewController, assignment: Assignment) {
        assignments.append(assignment)
    }
}

