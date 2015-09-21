//
//  SWCityGroups.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWCityGroups: NSObject {
    var title : String?
    var cities : [String]?
    
    convenience init(dict: Dictionary<String, AnyObject>) {
        self.init()
        
        self.title = dict["title"] as? String
        self.cities = dict["cities"] as? [String]
    }
}
