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
    @IBOutlet weak var avaterImage: UIImageView!
    
    var submission: Submission? {
        didSet{
            self.nameLabel.text = submission?.submittedAt
        }
    }
}
