//
//  StateListHandler.swift
//  PieDistrictDemo
//
//  Created by Anoop on 21/04/18.
//  Copyright © 2018 Anoop. All rights reserved.
//  Act as a controller 

import UIKit
import CoreData

class StateListHandler: NSObject {
    
    //This function return currently saved state list in ascending or descending order
    static func getAllStateList(isAscending: Bool, managedObjectContext:NSManagedObjectContext)->[State]{
        let  stateList = DataBaseHandler.getSavedList(managedObjectContext: managedObjectContext)
        let sortedList = self.sortStateList(stateList: stateList, isAscending: isAscending)
        return sortedList
    }
    
    //This function return an array which contain only state name
    static func getStateNameArray(managedObjectContext:NSManagedObjectContext)->[String]{
        let  stateList = DataBaseHandler.getSavedList(managedObjectContext: managedObjectContext)
        var stateNameArray = [String]()
        for state in stateList{
            stateNameArray.append(state.name!)
        }
        return stateNameArray
    }
    
    //Sort the state list in ascending and descending order based on flag
    static func sortStateList(stateList:[State],isAscending:Bool)->[State]{
        if isAscending {
            //Ascending order
            return stateList.sorted(by: { $0.name! < $1.name! })
        }else{
            //Descending
            return stateList.sorted(by: { $0.name! > $1.name! })
        }
        
    }

}
