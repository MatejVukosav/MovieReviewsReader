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
                       title: String) -> Recension {
        
        guard let context = mainContext else {
            fatalError("context not available")
        }

        return Recension.insert(into: context,
                    author: author,
                    comment: comment,
                    date: date,
                    displayTitle: displayTitle,
                    link: link,
                    multimedia: multimedia,
                    summaryShort: summaryShort,
                    title: title)
    }
    
    func createLink(suggestedLinkText: String,
                      url: String,
                      type: String) -> Link {
        
        guard let context = mainContext else {
            fatalError()
        }
        
        return Link.insert(into: context,
                    suggestedLinkText: suggestedLinkText,
                    url: url,
                    type: type)
    }
    
    func createMultimedia(src: String,
                        type: String,
                        height: Int32,
                        width: Int32) -> Multimedia {
        
        guard let context = mainContext else {
            fatalError()
        }
        
        return Multimedia.insert(into: context,
                          src: src,
                          type: type,
                          height: height,
                          width: width)
    }
    
    
    func createComment(withText text: String, author: String) -> Comment {
        
        guard let context = mainContext else {
            fatalError("context not available")
        }
        
        return Comment.insert(into: context, author: author, text: text)
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
    // primjeti da iako su nam metode koje stvaraju sve objekte sinkrone
    // da ova metoda kaja radi batch insert je dalje asinkrona te mozes jednostvno
    // zamjeniti main context s background contextom i na njemu raditi insert bez
    // da ti UI blokira
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
                // tako da napravis da rade sinkrono :)
               let multimedia = self.createMultimedia(
                    src: r.multimedia.src,
                    type: r.multimedia.type,
                    height: r.multimedia.height,
                    width: r.multimedia.width)
                
               //else put real user if login exists
               let comment = self.createComment(withText: "",author: "Matej")

               let link = self.createLink(suggestedLinkText: r.link.suggested_link_text,
                                                   url: r.link.url,
                                                   type: r.link.type)

                let recension = self.createRecension(author: r.byline,
                                                     comment: comment,
                                                     date: r.date_updated,
                                                     displayTitle: r.displayTitle,
                                                     link: link,
                                                     multimedia: multimedia,
                                                     summaryShort: r.summary_short,
                                                     title: r.headline)

                // force unwrap?? kako drugacije??
                // mozes napraviti da su ti u core data modelu te veze koje recenzija ima na link, comment,... opcionalne
                recension.multimedia = multimedia
                recension.link = link
                recension.comment = comment

                recension.displayTitle = r.displayTitle
                recension.title = r.headline
                recension.summaryShort = r.summary_short

                recensions.append(recension)
            }

            // maknuo sam save iz insert metoda jer nema potrebe
            // kad sve objekte napravis tek na kraju mozes save napraviti
            let status = context.saveOrRollback()
            print("context saved:", status)
            completion(recensions)
        }
    }
}

