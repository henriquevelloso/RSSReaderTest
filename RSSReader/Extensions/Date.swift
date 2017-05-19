//
//  Date.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import Foundation


extension Date {
    
    func formatToString(format:String = "dd/MM/yyyy HH:mm") ->  String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from:self)
        
        return dateString
        
    }
    
}
