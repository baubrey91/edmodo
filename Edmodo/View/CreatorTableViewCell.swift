//
//  CreatorTableViewCell.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import UIKit

class CreatorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var turnedInLabel: UILabel!
    @IBOutlet weak var avaterImage: CustomImageView!
    
    var submission: Submission? {
        didSet{
            self.nameLabel.text = submission?.creator.firstName
            self.turnedInLabel.text = submission?.submittedAt.formatDate(due: false)
            if let imgString = submission?.creator.avatar {
                avaterImage.loadImage(urlString: imgString)
            }
        }
    }
}
