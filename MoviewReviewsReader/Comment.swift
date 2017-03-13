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

public final class Comment: NSManagedObject {
    
   @NSManaged var date: Date
   @NSManaged var author: String
   @NSManaged var text: String
    
    //dodan public da bude vidljivost kao i klasa 
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.date = Date()
    }
    
    
    static func insert(into context: NSManagedObjectContext,
                       author: String,
                       text: String,
                     
                       completion: @escaping (Comment) -> () ){
                
        context.perform{
            let comment: Comment = context.insertObject()
            
            comment.text = text
            comment.author = author
            
            let status = context.saveOrRollback()
            print("context saved: ",status)
            completion(comment)
        }
    }
    
}


extension Comment: CoreDataManagedType {
    
}
