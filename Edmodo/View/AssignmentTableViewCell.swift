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
            self.assignmentDate.text = assignment?.dueAt.formatDateFromServer(due: true)
        }
    }
}

//This should be in a helper class
extension String {
    func formatDateFromServer(due: Bool) -> String {
        
        let prefix: String = due ? "due ": "turned in "
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                  //2015-06-09T00:22:24.000Z
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        if let date = dateFormatter.date(from: self) {
            return prefix + dateFormatterPrint.string(from: date)
        }
        return "unknown date"
    }
}
