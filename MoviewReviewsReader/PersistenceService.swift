//
//  PersistenceService.swift
//  MoviewReviewsReader
//
//  Created by user on 3/12/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class PersistenceService {
    
    private var managedModel: NSManagedObjectModel!
    private var persistenceCoordinator: NSPersistentStoreCoordinator!
    fileprivate var mainContext: NSManagedObjectContext!
    
    
    init(){
        guard let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)
            else{
                fatalError("model not found")
        }
        managedModel = model
        
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        persistenceCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        do {
            try persistenceCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                          configurationName:nil,
                                                          at: storeURL,
                                                          options:mOptions)
        } catch(_){
            fatalError("failed to add persistent store")
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistenceCoordinator
        
    }
    
    func fetchController<T: NSFetchRequestResult>(forRequest request: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        guard let mainContext = mainContext else {
            fatalError("coludn't get managed context")
        }
        
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }

    
    private var storeURL: URL{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return URL(fileURLWithPath:paths).appendingPathComponent("MovieReviewModel.sqlite")
    }
    
}

extension PersistenceService {
    
    func createComment(withText text: String,
                     date: String,
                     completion: @escaping (Comment) -> ()) {
        guard let mainContext = mainContext else {
            fatalError("context not available")
        }
        
      //  Comment.insert(into: mainContext, author: date, text: text){
      //      comment in completion(comment)
      //  }

    }
    
    func delete(comment: Comment) {
        guard let context = comment.managedObjectContext else {
            print("context not available")
            return
        }
        
        context.perform {
            context.delete(comment)
            let status = context.saveOrRollback()
            print("context saved:",  status)
        }
    }
}

