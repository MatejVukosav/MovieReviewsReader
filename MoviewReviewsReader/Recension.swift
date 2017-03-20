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
    
    @NSManaged var title: String
    @NSManaged var displayTitle: String
    @NSManaged var author: String
    @NSManaged var summaryShort: String
    @NSManaged var date: String
    @NSManaged var comment: Comment
    @NSManaged var link: Link
    @NSManaged var multimedia: Multimedia
    
    static func insert(into context: NSManagedObjectContext,
                       author: String,
                       comment: Comment,
                       date: String,
                       displayTitle: String,
                       link: Link,
                       multimedia: Multimedia,
                       summaryShort: String,
                       title: String) -> Recension {

        var savedRecension: Recension!
        context.performAndWait {
            savedRecension = context.insertObject() as Recension
            savedRecension.author = author
            savedRecension.comment = comment
            savedRecension.date = date
            savedRecension.displayTitle = displayTitle
            savedRecension.link = link
            savedRecension.multimedia = multimedia
            savedRecension.summaryShort = summaryShort
            savedRecension.title = title
        }
        return savedRecension
    }
    
//    static func insertIntoCoreData(into context: NSManagedObjectContext,
//                       author: String,
//                       comment: Comment,
//                       date: String,
//                       displayTitle: String,
//                       link: Link,
//                       multimedia: Multimedia,
//                       summaryShort: String,
//                       title: String) -> Recension {
//        context.perform {
//            let savedRecension: Recension = context.insertObject()
//            savedRecension.author = author
//            savedRecension.comment = comment
//            savedRecension.date = date
//            savedRecension.displayTitle = displayTitle
//            savedRecension.link = link
//            savedRecension.multimedia = multimedia
//            savedRecension.summaryShort = summaryShort
//            savedRecension.title = title
//            
//            return recension
//        }
//    }

    
}

extension Recension: CoreDataManagedType {
    
}
