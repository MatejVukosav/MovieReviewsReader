//
//  NSManagedObjectContext.swift
//  MoviewReviewsReader
//
//  Created by user on 3/12/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insertObject<A: CoreDataManagedType>() -> A {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A
            else{
                fatalError("Wrong object type")
        }
        return obj
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch(let error){
            print(error)
            rollback()
            return false
        }
    }
    
    func performChanges(block: @escaping() -> ()){
        perform {
            block()
            _=self.saveOrRollback()
        }
    }
    
    
}
