//
//  AppDelegate.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/27/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        self.window?.rootViewController = SWNavigationController(rootViewController: SWHomeViewController())
        self.window?.makeKeyAndVisible()
        return true
    }
    
    // 当其他应用跳转到本应用时就会调用这个方法 - 处理支付宝客户端返回结果
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return true
    }
}

