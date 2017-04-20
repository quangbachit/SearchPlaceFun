//
//  StoreService.swift
//  Search-Bach
//
//  Created by Quang Bach on 4/7/17.
//  Copyright © 2017 QuangBach. All rights reserved.
//

import Foundation



struct StoreService {
    var id: String
    var name: String
    var address: String
    var octime: String
    var rate: String
    var lat: String
    var long: String
    var type: String
    var district: String
    
    
    init?(result: JSONDictionary) {
        guard let _id = result["id"] else { return nil  }
        guard let _name = result["name"] else { return nil  }
        guard let _address = result["address"] else { return nil  }
        guard let _octime = result["octime"] else { return nil }
        guard let _rate = result["rate"] else { return nil }
        guard let _lat = result["lat"] else { return nil }
        guard let _long = result["long"] else { return nil }
        guard let _type = result["type"] as? String else { return nil }
        guard let _district = result["district"] else { return nil }
        
        self.id = _id as! String
        self.name = _name as! String
        self.address = _address as! String
        self.octime = _octime as! String
        self.rate = "\(_rate)"
        self.lat = "\(_lat)"
        self.long = "\(_long)"
        
        if _type == "Café/Dessert" {
            self.type = "coffee"
        } else {
            self.type = "restaurant"
        }
        
        self.district = _district as! String
        }
}
