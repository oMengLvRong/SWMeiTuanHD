//
//  SWDataTool.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//
//  数据管理

import UIKit

class SWDataTool: NSObject {
    
    /** 单例模式 */
    class var sharedInstance : SWDataTool {
        struct Singleton {
            static var instance = SWDataTool()
        }
        return Singleton.instance
    }
    
    private override init() {}
    
    /** 判断deal类型 */
    func getCategoryWithDeal(deal: SWDeal) -> SWCategory? {
        
        var category: SWCategory?
        
        let cs = self.categories
        let name = deal.categories.first
        for c in cs {
            if name == c.name {
                return c
            }
            if let sub = c.subcategories {
                if let n = name {
                    if contains(sub, n) {
                        return c
                    }
                }
            }
        }
        
        return category
    }
    
    /** SWCategory数据 */
    lazy var categories : [SWCategory]! = {
        var categories = [SWCategory]()
        let file = NSBundle.mainBundle().pathForResource("categories.plist", ofType: nil)
        var dictArray = NSArray(contentsOfFile: file!)
        
        for dict in (dictArray! as Array) {
            categories.append(SWCategory(dict: dict as! Dictionary<String, AnyObject>))
        }
        return categories
    }()
    
    /** SWCity数据 */
    lazy var cites : [SWCity]! = {
        var cites = [SWCity]()
        let file = NSBundle.mainBundle().pathForResource("cities.plist", ofType: nil)
        var dictArray = NSArray(contentsOfFile: file!)
        
        for dict in (dictArray! as Array) {
            cites.append(SWCity(dict: dict as! Dictionary<String, AnyObject>))
        }
        return cites
    }()
    
    /** SWCityGroups数据 */
    lazy var cityGroups : [SWCityGroups]! = {
        var cityGroups = [SWCityGroups]()
        let file = NSBundle.mainBundle().pathForResource("cityGroups.plist", ofType: nil)
        var dictArray = NSArray(contentsOfFile: file!)
        
        for dict in (dictArray! as Array) {
            cityGroups.append(SWCityGroups(dict: dict as! Dictionary<String, AnyObject>))
        }
        return cityGroups
    }()
    
    /** SWRegion数据 */
    lazy var regions : [SWRegion]! = {
        var regions = [SWRegion]()
        let file = NSBundle.mainBundle().pathForResource("cities.plist", ofType: nil)
        var dictArray = NSArray(contentsOfFile: file!)
        
        for dict in (dictArray! as Array) {
            regions.append(SWRegion(dict: dict as! Dictionary<String, AnyObject>))
        }
        return regions
    }()
    
    /** SWSort数据 */
    lazy var sorts : [SWSort]! = {
        var sorts = [SWSort]()
        let file = NSBundle.mainBundle().pathForResource("sorts.plist", ofType: nil)
        var dictArray = NSArray(contentsOfFile: file!)
        
        for dict in (dictArray! as Array) {
            sorts.append(SWSort(dict: dict as! Dictionary<String, AnyObject>))
        }
        return sorts
    }()
    
}
