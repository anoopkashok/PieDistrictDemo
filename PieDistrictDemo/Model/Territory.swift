//
//  Territory.swift
//  PieDistrictDemo
//
//  Created by Anoop on 20/04/18.
//  Copyright © 2018 Anoop. All rights reserved.
//

import UIKit

class Territory: NSObject {
    
    var abbr:String?
    var area:String?
    var capital:String?
    var country:String?
    var id:String?
    var largestCity:String?
    var name:String?
    
    init(id:String = "", name:String = "") {
        self.name = name
        self.id = id
    }
    
    //Parsing and create a state object from JSON
    static func getStateFromJson(json:[String:Any])-> Territory{
        
        let territory = Territory()
        if let _abbr = json["abbr"] as? String{
            territory.abbr = _abbr
        }
        if let _area = json["area"] as? String{
            territory.area = _area
        }
        if let _capital = json["capital"] as? String{
            territory.capital = _capital
        }
        if let _country = json["country"] as? String{
            territory.country = _country
        }
        if let _id = json["id"] as? String{
            territory.id = _id
        }
        if let _largest_city = json["largest_city"] as? String{
            territory.largestCity = _largest_city
        }
        if let _name = json["name"] as? String{
            territory.name = _name
        }
        
        return territory
        
    }
    

}
