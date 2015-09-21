//
//  SWCitySearchResultViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWCitySearchResultViewController: UITableViewController {

    var searchText : String = "" {
        didSet {
            // 转换成小写
            searchText = searchText.lowercaseString
            
            // 进行搜索
            handleSearchText()
        }
    }
    
    private var resultCities = [String]()
    
    private var cities = SWDataTool.sharedInstance.cites
    
    private func handleSearchText() {
        // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
//        var predicate = NSPredicate(format: "name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText)
//        if let results = cites.filteredArrayUsingPredicate(predicate) as? [String] {
//            resultCities = results
//        }
//        else {
//            println(cites.filteredArrayUsingPredicate(predicate) as? [String])
//            resultCities.removeAll(keepCapacity: false)
//        }
        resultCities.removeAll(keepCapacity: false)
        for (city : SWCity) in cities {
            // 城市的name中包含了searchText
            // 城市的pinYin中包含了searchText beijing
            // 城市的pinYinHead中包含了searchText
            if ((city.name?.rangeOfString(searchText) != nil) || (city.pinYin?.rangeOfString(searchText) != nil) || (city.pinYinHead?.rangeOfString(searchText) != nil) ) {
                resultCities.append(city.name!)
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultCities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id : String = "city"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: id)
        }
        
        cell?.textLabel?.text = resultCities[indexPath.row]
        
        return cell!
    }
    

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "共有\(resultCities.count)个搜索结果"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath \(indexPath.row)")
        
        // 获得选中的城市
        let city = resultCities[indexPath.row]
        // 发出通知
        NSNotificationCenter.defaultCenter().postNotificationName(SWCityDidChangeNotification, object: nil, userInfo: [SWSelectedCityName: city])
        
        // dissmiss自身
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
