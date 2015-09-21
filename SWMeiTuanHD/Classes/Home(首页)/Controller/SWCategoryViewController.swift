//
//  SWCategoryViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/28/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWCategoryViewController: UIViewController {

    // 数据源。分类数据
    var categories : [SWCategory]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1.加载分类数据
        categories = SWDataTool.sharedInstance.categories
        
        // 2.设置下拉视图尺寸
        let dropdown = SWHomeDropDown()
        dropdown.frame = CGRectMake(0, 0, 400, 400)
        // 设置该控制器在popover控制器内的尺寸
        self.preferredContentSize = dropdown.frame.size
        
        // 3.设置下拉视图代理
        dropdown.delegate = self
        dropdown.dateSource = self
        
        // 4.添加到父视图
        view.addSubview(dropdown)
    }
    
}

// MARK: - SWHomeDropdownDelegate

extension SWCategoryViewController : SWHomeDropdownDelegate {
    
    func didSelectRowInMainTable(row: Int) -> Void {
        println("didSelectRowInMainTable \(row)")
        
        // 假如点击的main row是全部或者右侧没有subregion 则发送通知
        if ((row == 0) || (categories[row].subcategories == nil)) {
            NSNotificationCenter.defaultCenter().postNotificationName(SWCategoryDidChangeNotification, object: nil, userInfo: [SWSelectedCategory: categories[row].name!])
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func didSelectRowInSubTable(row: Int, mainRow: Int) -> Void {
        println("didSelectRowInSubTable \(row) \(mainRow)")
        
        let userInfo = [
            SWSelectedCategory : categories[mainRow].name! ,
            SWSelectedSubCategory : categories[mainRow].subcategories![row]
        ]
        NSNotificationCenter.defaultCenter().postNotificationName(SWCategoryDidChangeNotification, object: nil, userInfo:  userInfo)
        
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - SWHomeDropdownDataSource

extension SWCategoryViewController : SWHomeDropdownDataSource {
    /**
    *  左边表格一共有多少行
    */
    func numberOfRowsInMainTable(sender: SWHomeDropDown) -> Int {
        return self.categories.count
    }
    
    /**
    *  左边表格每一行的标题
    *  @param row          行号
    */
    func titleForRowInMainTable(sender: SWHomeDropDown, row: Int) -> String {
        return self.categories[row].name!
    }
    
    /**
    *  左边表格每一行的子数据
    *  @param row          行号
    */
    func subdataForRowInMainTable(sender: SWHomeDropDown, row: Int) -> [String]? {
        return self.categories[row].subcategories
    }
    
    /**
    *  左边表格每一行的图标
    *  @param row          行号
    */
    func iconForRowInMainTable(sender: SWHomeDropDown, row: Int) -> String {
        return self.categories[row].small_icon!
    }
    
    /**
    *  左边表格每一行的选中图标
    *  @param row          行号
    */
    func selectedIconForRowInMainTable(sender: SWHomeDropDown, row: Int) -> String {
        return self.categories[row].small_highlighted_icon!
    }
}


