//
//  UITableView.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import Foundation
import UIKit


extension UITableView {
    
    func addDynamicRowHeight(_ estimatedRowHeight:CGFloat) {
        
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func removeFooterView() {
        self.tableFooterView = UIView()
    }
    
    func removeHeaderView() {
        self.tableHeaderView = UIView()
    }
    
    
    func clearsSelectionOnViewWillAppear() {
        
        if let row = self.indexPathForSelectedRow {
            self.deselectRow(at: row, animated: false)
        }
    }
    
}
