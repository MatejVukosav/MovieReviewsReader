//
//  Review.swift
//  MoviewReviewsReader
//
//  Created by user on 3/12/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation
import CoreData

final class Recension: NSManagedObject{
    
    var title: String = ""
    var displayTitle: String = ""
    var author: String = ""
    var summaryShort: String = ""
    var date: String = ""
    var comment: Comment = Comment()
    var link: Link = Link()
    var multimedia: Multimedia = Multimedia()
    
}
