//
//  RecipeFromURL+CoreDataProperties.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/26/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//
//

import Foundation
import CoreData


extension RecipeFromURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeFromURL> {
        return NSFetchRequest<RecipeFromURL>(entityName: "RecipeFromURL")
    }

    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var meal: String?
    @NSManaged public var name: String?
    @NSManaged public var rating: Int16
    @NSManaged public var url: String?

}
