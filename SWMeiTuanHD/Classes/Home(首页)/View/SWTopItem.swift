//
//  SWTopItem.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/28/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWTopItem: UIView {

    /** 设置为私有变量 */
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subTitle: UILabel!
    @IBOutlet private var iconBtn: UIButton!
    
    var view : UIView!
    var nibNmae : String = "SWTopItem"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set anything that uses the view or visable bounds
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup
        setup()
    }
    
    
    // MARK: - 公有方法
    func addTarget(target: AnyObject?, action: Selector) {
        iconBtn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setIcon(imageUrl: String, highlightedImageUrl: String) {
        iconBtn.setImage(UIImage(named: imageUrl), forState: UIControlState.Normal)
        iconBtn.setImage(UIImage(named: highlightedImageUrl), forState: UIControlState.Highlighted)
    }
    
    func setTitle(Text text: String){
        title.text = text
    }
    
    func setSubTitle(Text text: String){
        subTitle.text = text
    }
    
    // MARK: - 私人方法
    private func setup() {
        
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibNmae, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
