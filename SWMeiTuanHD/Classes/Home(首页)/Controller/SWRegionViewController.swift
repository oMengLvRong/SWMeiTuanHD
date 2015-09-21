//
//  SWRegionViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWRegionViewController: UIViewController {

    /** 这里是弱引用popoverController 否则会造成循环引用，因为popoverController初始化时会关联一个控制器(self) */
    weak var popover : UIPopoverController?
    
    var selectedRegion : [SWRegion]?
    
    @IBOutlet private var changeCity: UIButton!
    
    @IBAction func changeCity(sender: AnyObject) {
        // dismiss popover控制器
        self.popover?.dismissPopoverAnimated(true)
        
        // modal出一个选择地区的控制器
        let cityVc = SWCityViewController()
        println(cityVc.view.frame)
        let nav = SWNavigationController(rootViewController: cityVc)
        nav.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(nav, animated: true, completion: nil)
        
        // self.presentedViewController会引用着被modal出来的控制器
        // modal出来的是MTNavigationController
        // dismiss掉的应该也是MTNavigationController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 读取xib文件
        NSBundle.mainBundle().loadNibNamed("SWRegionViewController", owner: self, options: nil)
        
        // 设置下拉菜单
        let dropdownMenu = SWHomeDropDown()
        dropdownMenu.delegate = self
        dropdownMenu.dateSource = self
        dropdownMenu.frame = CGRectMake(0, 44, 320, 436)
        
        view.addSubview(dropdownMenu)
        
        preferredContentSize = CGSizeMake(320, 480)
        // Do any additional setup after loading the view.
    }
}

extension SWRegionViewController: SWHomeDropdownDelegate {
    
    func didSelectRowInMainTable(row: Int) -> Void {
        // 假如点击的main row是全部或者右侧没有subregion 则发送通知
        if((row == 0) || (selectedRegion?[row].subregions == nil)) {
            NSNotificationCenter.defaultCenter().postNotificationName(SWRegionDidChangeNotification, object: nil, userInfo: [SWSelectedMainRegion: selectedRegion![row].name!])
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func didSelectRowInSubTable(row: Int, mainRow: Int) -> Void {
        
        // 点击右边栏则直接发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(SWRegionDidChangeNotification, object: nil, userInfo:
            [SWSelectedRegion: selectedRegion![mainRow].subregions![row],
            SWSelectedMainRegion: selectedRegion![mainRow].name!])
        dismissViewControllerAnimated(true, completion: nil)
    }

}


extension SWRegionViewController: SWHomeDropdownDataSource {
    /**
    *  左边表格一共有多少行
    */
    func numberOfRowsInMainTable(sender: SWHomeDropDown) -> Int {
        return selectedRegion?.count ?? 0
    }
    
    /**
    *  左边表格每一行的标题
    *  @param row          行号
    */
    func titleForRowInMainTable(sender: SWHomeDropDown, row: Int) -> String {
        return selectedRegion?[row].name ?? ""
    }
    
    /**
    *  左边表格每一行的子数据
    *  @param row          行号
    */
    func subdataForRowInMainTable(sender: SWHomeDropDown, row: Int) -> [String]? {
        return selectedRegion?[row].subregions
    }
}

