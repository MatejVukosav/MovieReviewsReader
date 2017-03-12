//
//  Link.swift
//  MoviewReviewsReader
//
//  Created by user on 3/12/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation
import CoreData


final class Link: NSManagedObject {
    
    var suggestedLinkText: String = ""
    var url: String = ""
    var type: String = ""
}
