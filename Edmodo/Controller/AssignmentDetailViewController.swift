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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var assignment: Assignment?
    
    var submissions = [Submission]()
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.title = assignment?.title
        descriptionLabel.text = assignment?.description
        getSubmissions()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SubmissionDetailViewController
        let indexPath = tableView.indexPath(for: sender as! CreatorTableViewCell)!
        vc.submission = submissions[indexPath.row]
        vc.navTitle = assignment?.title
    }
    
    func getSubmissions() {
        if (Reachability.isConnectedToNetwork()) {
            //activityIndicator.startAnimating()
            EdmodoClient.sharedInstance.callAPI(endPoint: .getSubmissions(assignmentID: String(describing: assignment!.id),
                                                                          creatorID: String(describing: assignment!.creator.id),
                                                                          token: EdmodoClient.sharedInstance.token),
                                                parameters: ["page":1, "per_page":10],
                                                completionHandler: {
                                                    json in DispatchQueue.main.async {
                                                        self.submissions = Submission.submissions(array: json as! [payload])
                                                        self.tableView.reloadData()
                                                        //self.activityIndicator.stopAnimating()
                                                    }
            })
        }
        else {
            self.navigationItem.prompt = "Please Check Your internet connection"
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
