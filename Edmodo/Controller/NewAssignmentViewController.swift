//
//  NewAssignmentViewController.swift
//  Edmodo
//
//  Created by Brandon Aubrey on 9/7/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

protocol newAssignmentDelegate {
    func newAssignment(newAssignmentViewController: NewAssignmentViewController, assignment: Assignment)
}

class NewAssignmentViewController: UIViewController {
    //IBOutlets
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var assignmentTextView: UITextView!
    
    //variables
    var delegate: newAssignmentDelegate?
    
    //IBActions
    @IBAction func onCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSaveButton(_ sender: Any) {
        let avator: payload = ["large": User.loggedIn.avatar]
        let creator: payload = ["first_name": User.loggedIn.firstName,
                                "last_name": User.loggedIn.lastName,
                                "id": User.loggedIn.id,
                                "avatars":avator]
        
        print(datePicker.date)
        
        let dic: payload = ["title": titleTF.text,
                   "description": assignmentTextView.text,
                   "due_at": datePicker.date.description.formatDateFromPicker(),
                   "id": 1234,
                   "creator": creator]
        
        delegate?.newAssignment(newAssignmentViewController: self, assignment: Assignment(dic))
        self.dismiss(animated: true, completion: nil)
    }
}

extension String {
    func formatDateFromPicker() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +SSSS"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let date = dateFormatter.date(from: self) {
            return dateFormatterPrint.string(from: date)
        }
        return "unknown date"
    }
}


