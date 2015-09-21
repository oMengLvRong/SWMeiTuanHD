//
//  SWSort.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/30/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWSort: NSObject {
    var label : String?
    var value : Int?
    
    init(dict: Dictionary<String, AnyObject>) {
        self.label = dict["label"] as? String
        self.value = dict["value"] as? Int
    }
}
