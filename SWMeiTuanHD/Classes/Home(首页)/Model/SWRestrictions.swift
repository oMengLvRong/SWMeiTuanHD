//
//  SWRestrictions.swift
//  SWMeiTuanHD
//
//  Created by integrated on 9/14/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWRestrictions: EVObject {
   
    /** int	是否需要预约，0：不是，1：是 */
    var is_reservation_required: Int = 0
    
    /** int	是否支持随时退款，0：不是，1：是*/
    var is_refundable: Int = 0
    
    var special_tips: String = ""
    
//   override init() {}
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(is_reservation_required, forKey: "is_reservation_required")
//        aCoder.encodeObject(is_refundable, forKey: "is_refundable")
//        aCoder.encodeObject(special_tips, forKey: "special_tips")
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        is_reservation_required = aDecoder.decodeObjectForKey("is_reservation_required") as? String
//        is_refundable = aDecoder.decodeObjectForKey("is_refundable") as? String
//        special_tips = aDecoder.decodeObjectForKey("special_tips") as? String
//    }
}
