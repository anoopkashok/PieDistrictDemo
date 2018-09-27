//
//  NetworkInterface.swift
//  PieDistrictDemo
//
//  Created by Anoop on 20/04/18.
//  Copyright © 2018 Anoop. All rights reserved.
//

import UIKit
import CoreData

class NetworkInterface: NSObject {
    
    //Function to get all state list from URL
    static func getListOfState(managedObjectContext: NSManagedObjectContext, completionHandler: @escaping (_ responseObject: AnyObject?, _ count: Int, _ error: NSError?) -> ()) {
        
        //the json file url
        let URL_HEROES = "http://services.groupkt.com/state/get/IND/all"
        
        let url = URL(string: URL_HEROES)
        URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) -> Void in
            
            if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                print("not connected")
                let stateList = [State]()
                completionHandler(stateList as AnyObject?,stateList.count ,error)
                return
            }else{
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    if let result = jsonObj!.value(forKey: "RestResponse") as? NSDictionary{
                        
                        if let finalResult = result.value(forKey: "result") as? NSArray{
                            var territoryList = [Territory]()
                        DataBaseHandler.deleteAllEntries(managedObjectContext:managedObjectContext)
                            
                            for territory in finalResult{
                                let territory = Territory.getStateFromJson(json: territory as! [String : Any])
                                territoryList.append(territory)
                                DataBaseHandler.saveStateList(territory: territory, managedObjectContext: managedObjectContext)
                            }
                            completionHandler(territoryList as AnyObject?,territoryList.count ,nil)
                            
                        }
                        
                    }
                }
                
            }
            
        }).resume()
        
    }

}
