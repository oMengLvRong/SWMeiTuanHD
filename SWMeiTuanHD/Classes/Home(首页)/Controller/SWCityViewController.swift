//
//  SWCityViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWCityViewController: UIViewController {

    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    /** 注意cover是不覆盖在searchBar上的 */
    @IBOutlet private var cover: UIButton!

    
    @IBAction func coverClicked(sender: AnyObject) {
        searchBar.resignFirstResponder()
    }
    
    private var cityGroups = [SWCityGroups]()
    
    var selectedCity : String!
    
//    lazy private var searchResultView : () -> SWCitySearchResultViewController = {
//        var vc = SWCitySearchResultViewController()
//        [weak self] in
//            self.ta
//        return vc
//    }
    
     private var searchResult : SWCitySearchResultViewController? {
        didSet {
            if searchResult != nil {
                
                searchResult!.view.alpha = 0.0
                addChildViewController(searchResult!)
                view.addSubview(searchResult!.view)
                searchResult?.view.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: searchResult?.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: searchResult?.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: searchResult?.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0))
                view.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: searchResult?.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.读取xib文件
        NSBundle.mainBundle().loadNibNamed("SWCityViewController", owner: self, options: nil)
        
        // 2.设置导航栏
        navigationItem.title = "切换城市"
        navigationItem.leftBarButtonItem = UIBarButtonItem(target: self, action: "close", imageUrl: "btn_navigation_close", selectImageUrl: "btn_navigation_close_hl")
        searchResult = SWCitySearchResultViewController()
        
        // 3.设置索引颜色
        tableView.sectionIndexColor = UIColor.blackColor()
        
        // 4.设置搜索栏背景颜色
        searchBar.tintColor = UIColor(red: 32/255, green: 191/255, blue: 179/255, alpha: 1.0)
        
        // 5.读取数据源
        /** 由于mjextension 和 cfruntime 都有问题 ，自定义一个初始化 */
        cityGroups = SWDataTool.sharedInstance.cityGroups
    }

    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate

extension SWCityViewController : UISearchBarDelegate {
    
    // 当搜索栏开始编辑的时候
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        // 1.隐藏掉nav
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 2.searchbar往上爬
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield_hl")
        searchBar.setShowsCancelButton(true, animated: true)
        
        // 3.加上遮盖
        UIView.animateWithDuration(0.0, animations: { () -> Void in
            self.cover.alpha = 0.5
        })
    }
    
    // 当搜索栏结束编辑的时候
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        println("searchBarTextDidEndEditing")
        // 1.隐藏掉nav
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // 2.searchbar往下爬
        searchBar.backgroundImage = UIImage(named: "bg_login_textfield")
        searchBar.setShowsCancelButton(false, animated: true)
        
        // 3.取消遮盖
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.cover.alpha = 0.0
        })
    }
    
    // 当文本发生变化
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty { //为空
            searchResult?.view.alpha = 0.0
        } else {
            searchResult?.searchText = searchText
            searchResult?.view.alpha = 1.0
        }
    }
    
    // 当搜索栏的cancel键被点击
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDelegate

extension SWCityViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cityGroups[section].title!
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return cityGroups.map{$0.title!}
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 获得选中的城市
        let city : String! = cityGroups[indexPath.section].cities?[indexPath.row]
        
        // 发出通知
        NSNotificationCenter.defaultCenter().postNotificationName(SWCityDidChangeNotification, object: nil, userInfo: [SWSelectedCityName: city])
        
        // dismiss
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension SWCityViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityGroups[section].cities?.count ?? 0
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cityGroups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id : String = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: id)
            /** configure cell here */
        }
    
        var group = cityGroups[indexPath.section]
        cell!.textLabel?.text = group.cities?[indexPath.row]

        return cell!
    }
}
























