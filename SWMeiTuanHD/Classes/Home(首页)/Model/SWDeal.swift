//
//  SWDeal.swift
//  SWMeiTuanHD
//
//  Created by integrated on 8/24/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWDeal: EVObject {
    /** 团购单ID */
    var deal_id: String = ""
    /** 团购标题 */
    var title: String = ""
    /** 团购描述 */
    var desc: String = ""
    /** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber */
    /** 团购包含商品原价值 */
    var list_price: String = ""
    /** 团购价格 */
    var current_price: String = ""
    /** 团购当前已购买数 */
    var purchase_count: String = ""
    /** 团购图片链接，最大图片尺寸450×280 */
    var image_url: String = ""
    /** 小尺寸团购图片链接，最大图片尺寸160×100 */
    var s_image_url: String = ""
    /** 团购发布上线日期 */
    var publish_date: String = ""
    /** 团购过期日期 */
    var purchase_deadline: String = ""
    /** 订单详情页面 */
    var deal_h5_url: String = ""
    
    /** 编辑状态 */
    var edit: Bool = false
    /** 被选中 */
    var checking: Bool = false
    
    /** 团购限制条件 */
    var restrictions: SWRestrictions = SWRestrictions()
    
    /** 团购类型 */
    var categories: [String] = []
    
    /** 地址 */
    var businesses: [SWBusiness] = []
    
    override func propertyMapping() -> [(String?, String?)] {
        return [("desc","description")]
    }
//    /** 团购单ID */
//    var deal_id: String?
//    /** 团购标题 */
//    var title: String?
//    /** 团购描述 */
//    var desc: String?
//    /** 如果想完整地保留服务器返回数字的小数位数(没有小数\1位小数\2位小数等),那么就应该用NSNumber */
//    /** 团购包含商品原价值 */
//    var list_price: String?
//    /** 团购价格 */
//    var current_price: String?
//    /** 团购当前已购买数 */
//    var purchase_count: String?
//    /** 团购图片链接，最大图片尺寸450×280 */
//    var image_url: String?
//    /** 小尺寸团购图片链接，最大图片尺寸160×100 */
//    var s_image_url: String?
//    /** 团购发布上线日期 */
//    var publish_date: String?
//    /** 团购过期日期 */
//    var purchase_deadline: String?
//    /** 订单详情页面 */
//    var deal_h5_url: String?
//    
//    /** 编辑状态 */
//    var edit: Bool = false
//    /** 被选中 */
//    var checking: Bool = false
//    
//    /** 团购限制条件 */
//    var restrictions: SWRestrictions?
//    
//    /** 团购类型 */
//    var categories: [String]?
    
//    override init() {}
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(deal_id, forKey: "deal_id")
//        aCoder.encodeObject(title, forKey: "title")
//        aCoder.encodeObject(desc, forKey: "desc")
//        aCoder.encodeObject(list_price, forKey: "list_price")
//        aCoder.encodeObject(current_price, forKey: "current_price")
//        aCoder.encodeObject(purchase_count, forKey: "purchase_count")
//        aCoder.encodeObject(image_url, forKey: "image_url")
//        aCoder.encodeObject(s_image_url, forKey: "s_image_url")
//        aCoder.encodeObject(publish_date, forKey: "publish_date")
//        aCoder.encodeObject(purchase_deadline, forKey: "purchase_deadline")
//        aCoder.encodeObject(deal_h5_url, forKey: "deal_h5_url")
//        aCoder.encodeObject(edit, forKey: "edit")
//        aCoder.encodeObject(checking, forKey: "checking")
//        aCoder.encodeObject(restrictions, forKey: "restrictions")
//        aCoder.encodeObject(categories, forKey: "categories")
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        deal_id = aDecoder.decodeObjectForKey("deal_id") as? String
//        title = aDecoder.decodeObjectForKey("title") as? String
//        desc = aDecoder.decodeObjectForKey("desc") as? String
//        list_price = aDecoder.decodeObjectForKey("list_price") as? String
//        current_price = aDecoder.decodeObjectForKey("current_price") as? String
//        purchase_count = aDecoder.decodeObjectForKey("purchase_count") as? String
//        image_url = aDecoder.decodeObjectForKey("image_url") as? String
//        s_image_url = aDecoder.decodeObjectForKey("s_image_url") as? String
//        publish_date = aDecoder.decodeObjectForKey("publish_date") as? String
//        purchase_deadline = aDecoder.decodeObjectForKey("purchase_deadline") as? String
//        deal_h5_url = aDecoder.decodeObjectForKey("deal_h5_url") as? String
//        edit = aDecoder.decodeObjectForKey("edit") as! Bool
//        checking = aDecoder.decodeObjectForKey("checking") as! Bool
//        restrictions = aDecoder.decodeObjectForKey("restrictions") as? SWRestrictions
//        categories = aDecoder.decodeObjectForKey("categories") as? [String]
//    }
}
