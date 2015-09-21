//
//  UIBarButtonItem.swift
//  Demo02
//
//  Created by integrated on 7/21/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    
    convenience init(target: AnyObject?, action: Selector, imageUrl: String, selectImageUrl: String){
        
        let btn = UIButton()
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        // 2.设置图片
        btn.setBackgroundImage(UIImage(named: imageUrl), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: selectImageUrl), forState: UIControlState.Highlighted)
        
        // 3.设置尺寸
        btn.frame.size = btn.currentBackgroundImage!.size
        
        self.init(customView: btn)
    }
}

