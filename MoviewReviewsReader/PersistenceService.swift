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
                                                          at: storeURL, options:mOptions)
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
        
        return NSFetchedResultsController(fetchRequest: request,managedObjectContext: mainContext,sectionNameKeyPath: nil, cacheName: nil)
    }

    
    private var storeURL: URL{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return URL(fileURLWithPath:paths).appendingPathComponent("MovieReviewModel.sqlite")
    }
    
    public  func deleteCoreData(){
        deleteData(entity: "Recension")
        deleteData(entity: "Comment")
        deleteData(entity: "Link")
        deleteData(entity: "Multimedia")
    }
    
    private func deleteData(entity: String)
    {
        guard let managedContext = mainContext else {
            fatalError("context not available")
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
}

extension PersistenceService {

    
    func createRecension(author: String,
                       comment: Comment,
                       date: String,
                       displayTitle: String,
                       link: Link,
                       multimedia: Multimedia,
                       summaryShort: String,
                       title: String,
                       completion: @escaping (Recension) -> () ) {
        
        guard let context = mainContext else {
            fatalError("context not available")
        }
        
     
        
        Recension.insert(into: context,
                    author: author,
                    comment: comment,
                    date: date,
                    displayTitle: displayTitle,
                    link: link,
                    multimedia: multimedia,
                    summaryShort: summaryShort,
                    title: title) {
                        recension in completion(recension)
            }
    }
    
    func createLink(  suggestedLinkText: String,
                      url: String,
                      type: String,
                      completion: @escaping (Link) -> () ){
        
        guard let context = mainContext else {
            fatalError()
        }
        
        Link.insert(into: context,
                    suggestedLinkText: suggestedLinkText,
                    url: url,
                    type: type){
                        link in completion(link)
        }
    }
    
    func createMultimedia(src: String,
                        type: String,
                        height: Int32,
                        width: Int32,
                      completion: @escaping (Multimedia) -> () ){
        
        guard let context = mainContext else {
            fatalError()
        }
        
        Multimedia.insert(into: context,
                          src: src,
                          type: type,
                          height: height,
                          width: width){
                            multimedia in completion(multimedia)
        }
    }
    
    
    func createComment(withText text: String, author: String, completion: @escaping (Comment) -> ()) {
        
        guard let context = mainContext else {
            fatalError("context not available")
        }
        
        Comment.insert(into: context, author: author, text: text){
            comment in completion(comment)
        }

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
    
    //Save all recensions to core data
    func insertAllRecensions(
                       apiRecensions: [ApiRecension],
                       completion: @escaping ([Recension]) -> () ) {
        
        mainContext.perform {
            
            guard let context = self.mainContext else {
                fatalError("context not available")
            }
            
            var recensions: [Recension] = [Recension]()
            
            for r in apiRecensions {
                
                //TODO kako dohvatiti ove podatke da ih spremim u pojedinu recenziju ako se svako kreiranje izvrsava asinkrono??
                
                var multimedia:Multimedia?
                var comment: Comment?
                var link: Link?
                
               self.createMultimedia(
                    src: r.multimedia.src,
                    type: r.multimedia.type,
                    height: r.multimedia.height,
                    width: r.multimedia.width){
                        multimediaSaved in
                        print("Multimedia context saved: ", multimediaSaved)
                        
                }
                
                //else put real user if login exists
                self.createComment(withText: "",author: "Matej"){
                    commentSaved in
                    print("Comment context saved: ",commentSaved)
                }
                
                self.createLink(suggestedLinkText: r.link.suggested_link_text,
                                                   url: r.link.url,
                                                   type: r.link.type){
                                                    linkSaved in
                                                    print("Link saved: ", linkSaved)
                }
                
                self.createRecension(author: r.byline,
                                                     comment: comment,
                                                     date: r.date_updated,
                                                     displayTitle: r.displayTitle,
                                                     link: link,
                                                     multimedia: multimedia,
                                                     summaryShort: r.summary_short,
                                                     title: r.headline){
                    recension in print("Recension saved: ",recension)
                    recensions.append(recension)
                }
                
                
                /*
                recension.author =
                // force unwrap?? kako drugacije??
                recension.multimedia = multimedia!
                recension.link = link!
                recension.comment = comment!
                //
                recension.displayTitle = r.displayTitle
                recension.title = r.headline
                recension.summaryShort = r.summary_short

                */
 
            }
            
            let status = context.saveOrRollback()
            print("context saved:", status)
            completion(recensions)
        }
    }


}

