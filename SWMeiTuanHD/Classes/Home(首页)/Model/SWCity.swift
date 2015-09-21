//
//  SWCity.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWCity: NSObject {
    /** 城市名称 */
    var name : String?
    
    /** 区域名称 */
    var regions : [SWRegion]?
    
    /** 城市名称拼音 */
    var pinYin : String?
    var pinYinHead : String?
    
    convenience init(dict : Dictionary<String, AnyObject>) {
        self.init()
        self.name = dict["name"] as? String
        self.pinYin = dict["pinYin"] as? String
        self.pinYinHead = dict["pinYinHead"] as? String
        
        self.regions = [SWRegion]()
        // 因为有部分城市是没有区域的
        if let array = dict["regions"] as? Array<AnyObject>{
            for dic in array {
                regions?.append(SWRegion(dict: dic as! Dictionary<String, AnyObject>))
            }
        }
    }
}
