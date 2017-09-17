//
//  AssignmentViewController.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

class AssignmentsViewController: TableViewBase {

    //vars
    fileprivate var viewModel = AssignmentsViewModel()
    
    //MARK:- VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(selector: #selector(refreshData(refreshControl:)))
        configureInfinteScroll()
        viewModel.delegate = self
        checkInternetAndProceed(dataCall: .load)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.detail {
            let vc = segue.destination as! AssignmentDetailViewController
            let indexPath = tableView.indexPath(for: sender as! AssignmentTableViewCell)!
            vc.assignment = viewModel.assignments[indexPath.row]
        } else if segue.identifier == Segues.newAssignment {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! NewAssignmentViewController
            vc.delegate = self
        }
    }
    
    func refreshData(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        checkInternetAndProceed(dataCall: .refresh)
    }
    
    fileprivate func checkInternetAndProceed(dataCall: dataCall) {
        if Reachability.isConnectedToNetwork() {
            viewModel.getAssignments(dataCall: dataCall)
        } else {
            self.navigationItem.prompt = Warnings.noInternet
        }
    }
}

//MARK:- TablbleView Delegate
extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.assignment, for: indexPath) as! AssignmentTableViewCell
        cell.assignment = viewModel.assignments[indexPath.row]
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
                checkInternetAndProceed(dataCall: .append)
            }
        }
    }
}

//MARK:- new assignment protocol
extension AssignmentsViewController: newAssignmentDelegate {
    func newAssignment(newAssignmentViewController: NewAssignmentViewController, assignment: Assignment) {
        viewModel.assignments.append(assignment)
    }
}

