//
//  Comment.swift
//  MoviewReviewsReader
//
//  Created by user on 3/12/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class Comment: NSManagedObject {
    
   @NSManaged var date: String
   @NSManaged var author: String
   @NSManaged var text: String
    
    static func insert(into context: NSManagedObjectContext,
                       author: String,
                       text: String,
                       completion: @escaping (Comment) -> () ){
                
        context.perform{
            let comment: Comment = context.insertObject()
            comment.text = text
            comment.author = author
            comment.date = DateUtils.getCurrentDate()

            completion(comment)
        }
    }
    
    //Kako maknut to dupliciranje koda u modelima??
    static func insertIntoCoreData(into context: NSManagedObjectContext,
                       author: String,
                       text: String,
                       completion: @escaping (Comment) -> () ){
        
        context.perform{
            let comment: Comment = context.insertObject()
            comment.text = text
            comment.author = author
            comment.date = DateUtils.getCurrentDate()
            
            let status = context.saveOrRollback()
            print("context saved: ",status)
            completion(comment)
        }
    }
    
}


extension Comment: CoreDataManagedType {
    
}
