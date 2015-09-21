//
//  MTCategory.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/28/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit


class SWCategory: NSObject {
   
    /** 类别名称 */
    var name : String?
    
    /** 子类别名称 */
    var subcategories : [String]?
    
    /** 显示在下拉菜单的图标 */
    var small_highlighted_icon : String?
    var small_icon : String?
    
    /** 显示在导航栏的大图标 */
    var highlighted_icon : String?
    var icon : String?
    
    /** 显示在地图上的图标 */
    var map_icon : String?
    
    /** 由于mjextension 和 cfruntime 都有问题 ，自定义一个初始化 */
    convenience init(dict : Dictionary<String,AnyObject>) {
        self.init()
        self.name = dict["name"] as? String
        self.small_highlighted_icon = dict["small_highlighted_icon"] as? String
        self.small_icon = dict["small_icon"] as? String
        self.highlighted_icon = dict["highlighted_icon"] as? String
        self.icon = dict["icon"] as? String
        self.map_icon = dict["map_icon"] as? String
        
        self.subcategories = dict["subcategories"] as? [String]
    }
}
