//
//  SWHomeViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/27/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWHomeViewController: SWCollectionViewController {

    /** 导航栏上的按钮 */
    private var categoryItem : UIBarButtonItem!
    private var regionItem : UIBarButtonItem!
    private var sortItem : UIBarButtonItem!
    private var mapItem : UIBarButtonItem!
    private var searchItem : UIBarButtonItem!
    
    /** popover控制器 */
    private var categoryPopover : UIPopoverController?
    private var regionPopover : UIPopoverController?
    private var sortPopover : UIPopoverController?
    
    /** 请求参数 */
    private var selectedCity : String!
    private var selectedRegion : String!
    private var selectedCategory : String!
    private var selectedSubCategory : String?
    private var selectedSort : SWSort!
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: SWSelectedCityName, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: SWSelectedRegion, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置背景颜色
        self.collectionView!.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)

        // 设置导航栏属性
        self.setupLeftNav()
        self.setupRightNav()
        
        // 增加监听事件
        setupNotification()
        
        // 继承父类协议
        delegate = self
        
        // 设置左下角菜单
        setupAwesomeMenu()
    }

    // MAKR: - 设置左下角菜单
    
    func setupAwesomeMenu() {
        
        // 1.中间按钮
        let startItem = AwesomeMenuItem(image: UIImage(named: "icon_pathMenu_background_highlighted"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_mainMine_normal"), highlightedContentImage: nil)
        
        // 2.周边按钮
        let item0 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_collect_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_collect_highlighted"))
        let item1 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_collect_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_collect_highlighted"))
        let item2 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_collect_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_collect_highlighted"))
        let item3 = AwesomeMenuItem(image: UIImage(named: "bg_pathMenu_black_normal"), highlightedImage: nil, contentImage: UIImage(named: "icon_pathMenu_collect_normal"), highlightedContentImage: UIImage(named: "icon_pathMenu_collect_highlighted"))
        
        let items = [item0, item1, item2, item3]
        
        let awesomeMenu = AwesomeMenu(frame: CGRectZero, startItem: startItem, optionMenus: items)
        awesomeMenu.alpha = 0.5
        awesomeMenu.menuWholeAngle = CGFloat(M_PI_2)
        awesomeMenu.startPoint = CGPoint(x: 50, y: 150)
        awesomeMenu.delegate = self
        awesomeMenu.rotateAddButton = false
        view.addSubview(awesomeMenu)
        
        // 3.设置菜单永远在左下角
        awesomeMenu.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 0)
        awesomeMenu.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 0)
        awesomeMenu.autoSetDimensionsToSize(CGSizeMake(200, 200))

    }
    
    // MARK: - 设置导航栏内容
    
    func setupLeftNav() {
        
        let w : CGFloat = 140
        let h : CGFloat = 35
        
        // logo
        var logoItem = UIBarButtonItem(image: UIImage(named: "icon_meituan_logo"), style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        
        // 类别
        var categoryV = SWTopItem(frame: CGRectMake(0, 0, w, h))
        categoryV.addTarget(self, action: "categoryClicked")
        categoryV.setIcon("icon_district", highlightedImageUrl: "icon_district_highlighted")
        let categoryItem = UIBarButtonItem(customView: categoryV)
        self.categoryItem = categoryItem
        
        // 地区
        var regionV = SWTopItem(frame: CGRectMake(0, 0, w, h))
        regionV.addTarget(self, action: "regionClicked")
        regionV.setIcon("icon_district", highlightedImageUrl: "icon_district_highlighted")
        let regionItem = UIBarButtonItem(customView: regionV)
        self.regionItem = regionItem
        
        // 排序
        var sortV = SWTopItem(frame: CGRectMake(0, 0, w, h))
        sortV.addTarget(self, action: "sortClicked")
        sortV.setIcon("icon_sort", highlightedImageUrl: "icon_sort_highlighted")
        sortV.setTitle(Text: "排序")
        let sortItem = UIBarButtonItem(customView: sortV)
        self.sortItem = sortItem
        
        // 添加到导航栏
        navigationItem.leftBarButtonItems = [logoItem, categoryItem, regionItem, sortItem]
    }
    
    func setupRightNav() {
        
        // 地图按钮
        var mapBtn = UIBarButtonItem(target: self, action: "map", imageUrl: "icon_map", selectImageUrl: "icon_map_highlighted")
        self.mapItem = mapBtn

        // 搜索按钮
        var searchBtn = UIBarButtonItem(target: self, action: "search", imageUrl: "icon_search", selectImageUrl: "icon_search_highlighted")
        self.searchItem = searchBtn
        
        // 1.设置按钮位置
        var spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        spacer.width = 40
        
        // 2.加入到导航栏
        navigationItem.rightBarButtonItems = [mapBtn, spacer,searchBtn]
    }
    
    // MARK: - 增加监听事件 
    
    func setupNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categoryDidChange:", name: SWCategoryDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cityDidChange:", name: SWCityDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "regionDidChange:", name: SWRegionDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sortDidChange:", name: SWSortDidChangeNotification, object: nil)
    }

}

 // MARK: - 监听响应时间

extension SWHomeViewController {
    
    func categoryDidChange(notification: NSNotification) {
        selectedCategory = notification.userInfo?[SWSelectedCategory] as! String
        selectedSubCategory = notification.userInfo?[SWSelectedSubCategory] as? String
        
        // 更换顶部区域category的文字
        let topItem = categoryItem.customView as! SWTopItem
        topItem.setTitle(Text: selectedCategory)
        
        // 更换顶部区域sub category文字
        if (selectedSubCategory == nil) || (selectedSubCategory == "全部"){
            topItem.setSubTitle(Text: "")
        }
        else {
            topItem.setSubTitle(Text: selectedSubCategory!)
        }
        collectionView?.headerBeginRefreshing()
    }
    
    func cityDidChange(notification: NSNotification) {
        selectedCity = notification.userInfo?[SWSelectedCityName] as! String
        println("selectedCity = \(selectedCity)")
        
        // 更换顶部区域item的文字
        let topItem = regionItem.customView as! SWTopItem
        topItem.setTitle(Text: selectedCity)
        topItem.setSubTitle(Text: "")
        
        // TODO: - 刷新表格数据
        collectionView?.headerBeginRefreshing()
    }
    
    func regionDidChange(notification: NSNotification) {
        selectedRegion = notification.userInfo?[SWSelectedRegion] as? String
        let selectedMainRegion = notification.userInfo?[SWSelectedMainRegion] as? String
        println("selectedRegion = \(selectedRegion)")
        
        // 更换顶部区域item的文字
        if selectedRegion != "全部" {
            let topItem = regionItem.customView as! SWTopItem
            topItem.setTitle(Text: selectedCity + "-" + (selectedMainRegion ?? ""))
            topItem.setSubTitle(Text: selectedRegion ?? "")
        }
        // TODO: - 刷新表格数据
        collectionView?.headerBeginRefreshing()
    }
    
    func sortDidChange(notification: NSNotification) {
        let sort = notification.userInfo?[SWSelectedSort] as! SWSort
        selectedSort = sort
        
        let topItem = sortItem.customView as! SWTopItem
        topItem.setTitle(Text: sort.label!)
        topItem.setSubTitle(Text: "")
        
        // TODO: - 刷新表格数据
        collectionView?.headerBeginRefreshing()
    }
}

 // MARK: - 顶栏点击出发事件

extension SWHomeViewController {
    func search() {
        let searchVc = SWSearchController()
        
        if selectedCity == nil {
            MBProgressHUD.showError("请选择城市")
            return
        }
        searchVc.cityName = selectedCity
        let nav = SWNavigationController(rootViewController: searchVc)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func map() {
        let nav = SWNavigationController(rootViewController: SWMapController())
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func categoryClicked() {
        // 显示分类菜单
        self.categoryPopover = UIPopoverController(contentViewController: SWCategoryViewController())
        self.categoryPopover!.presentPopoverFromBarButtonItem(categoryItem, permittedArrowDirections: .Any, animated: true)
    }
    
    func regionClicked() {
        // 显示地区目录
        
        // 得到当前选中城市的区域
        var selectedRegion : [SWRegion]?
        if selectedCity != nil {
            let cities = SWDataTool.sharedInstance.cites
            for c in cities {
                if c.name == selectedCity {
                    selectedRegion = c.regions
                    break
                }
            }
        }
        
        let regionVc = SWRegionViewController()
        //
        regionVc.selectedRegion = selectedRegion
        self.regionPopover = UIPopoverController(contentViewController: regionVc)
        regionVc.popover = regionPopover
        self.regionPopover!.presentPopoverFromBarButtonItem(regionItem, permittedArrowDirections: .Any, animated: true)
    }
    
    func sortClicked() {
        // 显示排列菜单
        let sortVc = SWSortViewController()
        self.sortPopover = UIPopoverController(contentViewController: sortVc)
        sortVc.popover = sortPopover
        self.sortPopover!.presentPopoverFromBarButtonItem(sortItem, permittedArrowDirections: .Any, animated: true)
    }
}

// MARK: - awesome menu 代理事件

extension SWHomeViewController: AwesomeMenuDelegate {
    func awesomeMenu(menu: AwesomeMenu!, didSelectIndex idx: Int) {
        if idx == 0 { // 收藏纪录
            let nav = SWNavigationController(rootViewController: SWEnshireController())
            presentViewController(nav, animated: true, completion: nil)
        } else if idx == 1 {
            let nav = SWNavigationController(rootViewController: SWRecentViewController())
            presentViewController(nav, animated: true, completion: nil)
        }
    }
}

// MARK: - SWCollectionViewControllerDelegate 代理事件

extension SWHomeViewController: SWCollectionViewControllerDelegate {
    func setParams(inout params: NSMutableDictionary) {
        // 城市
        params["city"] = selectedCity ?? "全国"
        // 分类(类别)
        if (selectedCategory != nil && selectedCategory != "") {
            if selectedCategory == "全部分类" {
                MBProgressHUD.showError("请选择一个分类")
            } else {
                params["category"] = selectedCategory
            }
        }
        // 区域
        if (selectedRegion != nil && selectedRegion != "") {
            params["region"] = selectedRegion
        }
        // 排序
        if (selectedSort != nil) {
            params["sort"] = String(selectedSort.value!)
        }

    }
}
