//
//  TableViewBase.swift
//  Edmodo
//
//  Created by Brandon Aubrey on 9/16/17.
//  Copyright © 2017 BrandonAubrey. All rights reserved.
//

import Foundation
import UIKit

class TableViewBase: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let refreshControlTable = UIRefreshControl()
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    func configureInfinteScroll() {
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
    
    func setupTableView(selector: Selector) {
        refreshControlTable.addTarget(self, action: selector, for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControlTable, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
}

extension TableViewBase: ViewModelDelegate {
    func loadAssignments() {
        self.tableView?.reloadData()
        self.activityIndicator.stopAnimating()
    }
    
    func resfreshAssignments() {
        self.tableView?.reloadData()
        self.refreshControlTable.endRefreshing()
    }
    
    func appendAssignments() {
        self.tableView?.reloadData()
        self.loadingMoreView?.stopAnimating()
    }
}
