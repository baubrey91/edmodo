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

    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var assignment: Assignment?
    fileprivate var page = 1
    fileprivate var perPage = 10
    fileprivate var isMoreDataLoading = false
    fileprivate var loadingMoreView: InfiniteScrollActivityView?
    var submissions = [Submission]()
    
    //MARK:- VIEW LIFECYCLE
    override func viewDidLoad() {
        setupTableView()
        configureInfinteScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.title = assignment?.title
        descriptionLabel.text = assignment?.description
        getSubmissions(append: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SubmissionDetailViewController
        let indexPath = tableView.indexPath(for: sender as! CreatorTableViewCell)!
        vc.submission = submissions[indexPath.row]
        vc.navTitle = assignment?.title
    }
    
    //TableView Configuration
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

    //MARK:- API calls
    func refreshData(refreshControl: UIRefreshControl) {
        if (Reachability.isConnectedToNetwork()) {
            page = 1
            perPage = 10
            EdmodoClient.sharedInstance.callAPI(endPoint: .getSubmissions(assignmentID: String(describing: assignment!.id),
                                                                          creatorID: String(describing: assignment!.creator.id),
                                                                          token: User.loggedIn.token),
                                                parameters: ["page":page, "per_page":perPage],
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.submissions = Submission.submissions(array: json as! [payload])
                                                        self.tableView.reloadData()
                                                        refreshControl.endRefreshing()
                                                    }
            })
        }
        else {
            self.navigationItem.prompt = "Please Check Your internet connection"
        }
        
    }
    
    fileprivate func getSubmissions(append: Bool) {
        if (Reachability.isConnectedToNetwork()) {
            if append {
                perPage += 10
            } else {
                perPage = 10
                page = 1
                activityIndicator.startAnimating()
            }
            EdmodoClient.sharedInstance.callAPI(endPoint: .getSubmissions(assignmentID: String(describing: assignment!.id),
                                                                          creatorID: String(describing: assignment!.creator.id),
                                                                          token: User.loggedIn.token),
                                                parameters: ["page": page, "per_page": perPage],
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.submissions = Submission.submissions(array: json as! [payload])
                                                        self.tableView.reloadData()
                                                        if append {
                                                            self.loadingMoreView!.stopAnimating()
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

//MARK:- TABLEVIEW
extension AssignmentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "creatorCell", for: indexPath) as! CreatorTableViewCell
        cell.submission = submissions[indexPath.row]
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
                
                getSubmissions(append: true)
            }
        }
    }
}
