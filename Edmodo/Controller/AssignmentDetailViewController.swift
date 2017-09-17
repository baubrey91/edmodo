//
//  AssignmentDetailViewController.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

class AssignmentDetailViewController: TableViewBase {

    //IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //Variables
    var assignment: Assignment!
    fileprivate var viewModel: AssignmentDetailViewModel!
    
    //MARK:- VIEW LIFECYCLE
    override func viewDidLoad() {
        setupTableView(selector: #selector(refresh(refreshControl:)))
        configureInfinteScroll()
        viewModel = AssignmentDetailViewModel(id: String(describing: assignment.id),
                                              creatorId: String(describing: assignment.creator.id))
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.title = assignment?.title
        descriptionLabel.text = assignment?.description
        viewModel.getSubmissions(dataCall: .load)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SubmissionDetailViewController
        let indexPath = tableView.indexPath(for: sender as! CreatorTableViewCell)!
        vc.submission = viewModel.submissions[indexPath.row]
        vc.navTitle = assignment?.title
    }
    
    //TableView Configuration

    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        checkInternetAndProceed(dataCall: .append)
    }
    
    fileprivate func checkInternetAndProceed(dataCall: dataCall) {
        if Reachability.isConnectedToNetwork() {
            viewModel.getSubmissions(dataCall: dataCall)
        } else {
            self.navigationItem.prompt = Warnings.noInternet
        }
    }
}

//MARK:- TABLEVIEW
extension AssignmentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.creator, for: indexPath) as! CreatorTableViewCell
        cell.submission = viewModel.submissions[indexPath.row]
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

