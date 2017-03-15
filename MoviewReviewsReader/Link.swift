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
    
    @NSManaged var suggestedLinkText: String
    @NSManaged var url: String
    @NSManaged var type: String
    
    static func insert(into context: NSManagedObjectContext,
                       suggestedLinkText: String,
                       url: String,
                       type: String,
                        completion: @escaping (Link) -> () )  {
            context.perform {
            let link: Link = context.insertObject()
            link.suggestedLinkText = suggestedLinkText
            link.url = url
            link.type = type
          completion(link)
        }
    }
    
    static func insertIntoCoreData(into context: NSManagedObjectContext,
                       suggestedLinkText: String,
                       url: String,
                       type: String,
                       completion: @escaping (Link) -> () ) {
        context.perform {
            let link: Link = context.insertObject()
            link.suggestedLinkText = suggestedLinkText
            link.url = url
            link.type = type
            
            let status = context.saveOrRollback()
            print("context saved:", status)
            completion(link)
        }
    }


}

extension Link: CoreDataManagedType {
    
}
