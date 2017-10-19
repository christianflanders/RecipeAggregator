//
//  PercistanceService.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/15/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import Foundation
import CoreData

final class PersistanceService{
    
    
    static let store = PersistanceService()
    
    private init(){}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var fetchedRecipes = [RecipeFromURL]()
    
    
    
    func storeRecipe(withTitle title: String, url: String, date: NSDate){
        let recipe = RecipeFromURL(context: context)
        recipe.url = url
        recipe.name = title
        recipe.dateAdded = date
        recipe.meal = "Unsorted"
//        print("adding preview image url, \(recipe.previewImageURL)")
        try! context.save()
        print("Storing...")
        fetchRecipes()
    }
    
    func fetchRecipes() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeFromURL")
        let dateSort = NSSortDescriptor(key:"dateAdded", ascending:false)
        fetchRequest.sortDescriptors = [dateSort]
        self.fetchedRecipes = try! context.fetch(fetchRequest) as! [RecipeFromURL]
    }
    
    func delete(recipe: RecipeFromURL){
        context.delete(recipe)
        try! context.save()
    }
    
    
    lazy var persistentContainer: CustomPersistantContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = CustomPersistantContainer(name: "RecipeModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
   

    // MARK: - Core Data Saving support
    
     func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
 
}


class CustomPersistantContainer : NSPersistentContainer {
    
    static let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.christianflanders.RecipeAggregator")!
    let storeDescription = NSPersistentStoreDescription(url: url)
    
    override class func defaultDirectoryURL() -> URL {
        return url
    }
}
