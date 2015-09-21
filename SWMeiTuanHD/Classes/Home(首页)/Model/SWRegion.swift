//
//  SWRegion.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWRegion: NSObject {
    /** 区域名字 */
    var name : String?
    
    /** 子区域 */
    var subregions : [String]?
    
    convenience init(dict : Dictionary<String, AnyObject>) {
        self.init()
        
        self.name = dict["name"] as? String
        self.subregions = dict["subregions"] as? [String]
    }
}
