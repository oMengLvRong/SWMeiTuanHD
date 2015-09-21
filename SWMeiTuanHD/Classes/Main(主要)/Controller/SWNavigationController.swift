//
//  SWNavigationController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/27/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWNavigationController: UINavigationController {

    /** oc中initialize方法 */
    override class func initialize () {
        var bar = UINavigationBar.appearance()
        bar.setBackgroundImage(UIImage(named: "bg_navigationBar_normal"), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
