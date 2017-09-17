//
//  Constants.swift
//  Edmodo
//
//  Created by Brandon Aubrey on 9/16/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

struct Warnings {
    static let noInternet = "Please Check Your internet connection"
}

struct Segues {
    static let newAssignment = "newAssignmentSegue"
    static let detail = "assignmentDetailSegue"
}

struct Cells {
    static let creator = "creatorCell"
    static let assignment = "assignmentCell"
}

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)
}
