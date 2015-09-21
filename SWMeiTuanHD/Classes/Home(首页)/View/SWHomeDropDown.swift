//
//  SWHomeDropDown.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/28/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

@objc protocol SWHomeDropdownDataSource : class {
    /**
    *  左边表格一共有多少行
    */
    func numberOfRowsInMainTable(sender: SWHomeDropDown) -> Int
    
    /**
    *  左边表格每一行的标题
    *  @param row          行号
    */
    func titleForRowInMainTable(sender: SWHomeDropDown, row: Int) -> String
    
    /**
    *  左边表格每一行的子数据
    *  @param row          行号
    */
    func subdataForRowInMainTable(sender: SWHomeDropDown, row: Int) -> [String]?
    
    /**
    *  左边表格每一行的图标
    *  @param row          行号
    */
    optional func iconForRowInMainTable(sender: SWHomeDropDown, row: Int) -> String
    
    /**
    *  左边表格每一行的选中图标
    *  @param row          行号
    */
    optional func selectedIconForRowInMainTable(sender: SWHomeDropDown, row: Int) -> String
}

@objc protocol SWHomeDropdownDelegate : class {
    
    func didSelectRowInMainTable(row: Int) -> Void
    
    func didSelectRowInSubTable(row: Int, mainRow: Int) -> Void
}

class SWHomeDropDown: UIView {

    @IBOutlet private var mainTableView: UITableView!
    @IBOutlet private var subTableView: UITableView!
    
    private var view : UIView!
    private var nibNmae : String = "SWHomeDropdown"
    
    // 代理
    weak var dateSource : SWHomeDropdownDataSource?
    weak var delegate : SWHomeDropdownDelegate?
    
    private var clickedMainRow : Int = 0
    
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

    
    // MARK: - 私人方法
    private func setup() {
        view = loadViewFromNib()
        
        /** 如果固定尺寸则设置为不可以拉伸，反之设置为可拉伸则不需要设置尺寸，由初始化来决定 */
        /** 注释内也可用 */
//        bounds = CGRectMake(0, 0, 480, 320)
//        view.autoresizingMask = .None
        
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        subTableView.delegate = self
        subTableView.dataSource = self
        
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibNmae, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
}


// MARK: - UITableViewDelegate

extension SWHomeDropDown : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 假如是主表的话
        if tableView == mainTableView {
            // 1.纪录下被点击的栏目
            clickedMainRow = indexPath.row
            // 2.刷新右表的数据
            subTableView.reloadData()
            // 3.将该事件通知代理
            if let delegate = self.delegate {
                delegate.didSelectRowInMainTable(indexPath.row)
            }
        }
        // 从表
        else {
            if let delegate = self.delegate {
                delegate.didSelectRowInSubTable(indexPath.row, mainRow: clickedMainRow)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension SWHomeDropDown : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRow : Int = 0
        
        if tableView == mainTableView {
            if let dateSource = self.dateSource {
                numberOfRow = dateSource.numberOfRowsInMainTable(self)
            }
        }
        else {
            if let dateSource = self.dateSource {
                if let array = dateSource.subdataForRowInMainTable(self, row: self.clickedMainRow) {
                    numberOfRow = array.count
                }
            }
        }
        return numberOfRow
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        // 主表
        if tableView == mainTableView {
            
            cell = SWDropdownMainCell.cellWithTableView(tableView)
            
            // 取出数据模型
            if let dataSource = self.dateSource {
                
                cell!.textLabel?.text = self.dateSource?.titleForRowInMainTable(self, row: indexPath.row)
                
                if let iconUrl = dataSource.iconForRowInMainTable?(self, row: indexPath.row) {
                    cell!.imageView?.image = UIImage(named: iconUrl)
                }
                if let selectIconUrl = dataSource.selectedIconForRowInMainTable?(self, row: indexPath.row) {
                    cell!.imageView?.highlightedImage = UIImage(named: selectIconUrl)
                }
                
                // 取出从表数据
                let subData = dataSource.subdataForRowInMainTable(self, row: indexPath.row)
                
                // 根据从表数据加载标志
                if subData != nil {
                    cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                }
                else {
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
                
            }
        }
        else { // 从表
            cell = SWDropdownSubCell.cellWithTableView(tableView)
            
            //cell?.contentView.backgroundColor = UIColor(red: 0.929, green: 0.929, blue: 0.929, alpha: 1.0)
            
            if let dataSource = self.dateSource {
                let subData = dataSource.subdataForRowInMainTable(self, row: clickedMainRow)
                cell!.textLabel?.text = subData?[indexPath.row]
            }
        }
            
        return cell!
    }

}
