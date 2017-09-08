//
//  AssignmentTableViewCell.swift
//  Edmodo
//
//  Created by Brandon on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet weak var assignmentTitle: UILabel!
    @IBOutlet weak var assignmentDate: UILabel!

    var assignment: Assignment? {
        didSet {
            self.assignmentTitle.text = assignment?.title
            self.assignmentDate.text = assignment?.dueAt
        }
    }
}
