//
//  SWSortViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/30/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWSortButton: UIButton {
    
    private var sort : SWSort! {
        didSet {
            setTitle(sort.label, forState: UIControlState.Normal)
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        self.setBackgroundImage(UIImage(named: "btn_filter_normal"), forState: UIControlState.Normal)
        self.setBackgroundImage(UIImage(named: "btn_filter_selected"), forState: UIControlState.Highlighted)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SWSortViewController: UIViewController {
    
    var popover : UIPopoverController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let btnW : CGFloat = 100
        let btnH : CGFloat = 30
        let toppadding : CGFloat = 10
        let leftpadding : CGFloat = 15
        let rightpadding : CGFloat = 15
        let bottompadding : CGFloat = 10
        
        // 1.加载模型数据
        var sorts : [SWSort] = SWDataTool.sharedInstance.sorts
        println(sorts)
        
        // 2.初始化button数组
        var buttons = [SWSortButton]()
        
        // 3.设置button位置
        for i in 0..<7 {
            var button = SWSortButton(frame: CGRectMake(leftpadding, toppadding + CGFloat(i)*(bottompadding + btnH), btnW, btnH))
            button.sort = sorts[i]
            button.tag = i
            button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(button)
            buttons.append(button)
        }
        
        // 4.设置控制器在popover里的大小
        preferredContentSize = CGSizeMake(btnW + leftpadding + rightpadding, toppadding + 7*(bottompadding + btnH))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 按键触发事件（通过view.tag来区分是哪个按钮）
    func buttonClicked(sender: SWSortButton) -> Void {
        println("clicked \(sender.tag)")
        
        // 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(SWSortDidChangeNotification, object: nil, userInfo: [SWSelectedSort: sender.sort])
        
        // dismiss popover
        self.popover?.dismissPopoverAnimated(true)
    }
}
