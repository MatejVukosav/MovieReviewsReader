//
//  DateUtils.swift
//  MoviewReviewsReader
//
//  Created by matej on 3/15/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation

public class DateUtils{
    
    static func getCurrentDate() -> String {
        
        //current date
        let currentdate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formatedDate = dateFormatter.string(from:currentdate)
        return formatedDate
    }
}
