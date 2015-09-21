//
//  SWSearchController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 9/15/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWSearchController: SWCollectionViewController {
   
    var cityName = String()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = "请输入关键词"
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.delegate = self
        
        // 左邊的返回鍵
        navigationItem.leftBarButtonItems = [UIBarButtonItem(target: self, action: "back", imageUrl: "icon_back", selectImageUrl: "icon_back_highlighted")]
        
        // 搜索欄
        navigationItem.titleView = searchBar
        
        println(cityName)
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension SWSearchController: SWCollectionViewControllerDelegate {
    func setParams(inout params: NSMutableDictionary) {
        
        params["city"] = cityName
        params["keyword"] = searchBar.text
    }
}

extension SWSearchController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        collectionView?.headerBeginRefreshing()
        view.endEditing(true)
    }
}
