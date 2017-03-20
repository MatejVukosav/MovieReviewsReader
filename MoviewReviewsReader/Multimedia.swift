//
//  Multimedia.swift
//  MoviewReviewsReader
//
//  Created by user on 3/12/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation
import CoreData


final class Multimedia: NSManagedObject{
    
    @NSManaged var src: String
    @NSManaged var type: String
    @NSManaged var height: Int32
    @NSManaged var width: Int32
    
    static func insert(into context: NSManagedObjectContext,
                       src: String,
                       type: String,
                       height: Int32,
                       width: Int32) -> Multimedia {
        var multimedia: Multimedia!
        context.performAndWait {
            multimedia = context.insertObject() as Multimedia
            multimedia.src = src
            multimedia.type = type
            multimedia.height = height
            multimedia.width = width
        }
        return multimedia
    }
    
//    static func insertIntoCoreData(into context: NSManagedObjectContext,
//                       src: String,
//                       type: String,
//                       height: Int32,
//                       width: Int32) -> Multimedia {
//
//        context.performAndWait {
//            let multimedia: Multimedia = context.insertObject()
//            multimedia.src = src
//            multimedia.type = type
//            multimedia.height = height
//            multimedia.width = width
//            
//            return multimedia
//        }
//    }
}
extension Multimedia: CoreDataManagedType {
    
}
