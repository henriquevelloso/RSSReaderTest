//
//  String.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import Foundation



extension String {
    
    func removeHtmlTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)        
    }
    
}
