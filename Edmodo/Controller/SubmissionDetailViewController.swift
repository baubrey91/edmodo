//
//  SubmissionDetailViewController.swift
//  Edmodo
//
//  Created by Brandon on 9/8/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

class SubmissionDetailViewController: UIViewController {
    //IBOutlets
    @IBOutlet weak var creatorImage: CustomImageView!
    @IBOutlet weak var creatorName: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var submissionDetails: UITextView!
    
    //Variables
    var submission: Submission?
    var navTitle: String?
    
    //ViewLifeCycle
    override func viewWillAppear(_ animated: Bool) {
        self.title = navTitle
        creatorName.text = submission?.creator.firstName
        createdDate.text = submission?.submittedAt.formatDateFromServer(due: false)
        submissionDetails.text = submission?.content
        
        if let imgString = submission?.creator.avatar {
            creatorImage.loadImage(urlString: imgString)
        }
    }
}
