//
//  DataBaseHandler.swift
//  PieDistrictDemo
//
//  Created by Anoop on 20/04/18.
//  Copyright © 2018 Anoop. All rights reserved.
//

import UIKit
import CoreData

class DataBaseHandler: NSObject {
    
    //Function to save an item to core data
    static func saveStateList(territory: Territory,managedObjectContext:NSManagedObjectContext ){
        
        let itemToSave: State = NSEntityDescription.insertNewObject(forEntityName: "State", into: managedObjectContext) as! State
        
        itemToSave.name = territory.name
        itemToSave.abbr = territory.abbr
        itemToSave.id = territory.id
        itemToSave.largest_city = territory.largestCity
        itemToSave.capital = territory.capital
        itemToSave.country = territory.country
        itemToSave.area = territory.area
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Call this function to delete already added entries from core data
    static func deleteAllEntries(managedObjectContext: NSManagedObjectContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
        
    }
    
    //Function to get saved list from core data
    static func getSavedList(managedObjectContext: NSManagedObjectContext)->[State] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "State")
        var stateArray = [State]()
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if let  items = results as? [State]{
                stateArray = items
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return stateArray
    }

}
