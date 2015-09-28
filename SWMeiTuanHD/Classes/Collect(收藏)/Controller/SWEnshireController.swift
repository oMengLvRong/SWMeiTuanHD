//
//  SWEnshireController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 9/10/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWEnshireController: UICollectionViewController {
    
    let enshireReuseIdentifier = "enshireReuseIdentifier"
    
    let doneTitle = "完成"
    let editTitle = "编辑"
    
    var curPage = Int()

    lazy var backItem: UIBarButtonItem = {
        return UIBarButtonItem(target: self, action: "back", imageUrl: "icon_back", selectImageUrl: "icon_back_highlighted")
    }()
    
    lazy var selectAllItem: UIBarButtonItem = {
        return UIBarButtonItem(title: " 全选 ", style: UIBarButtonItemStyle.Done, target: self, action: "selectAll")
    }()
    
    lazy var unselectAllItem: UIBarButtonItem = {
        return UIBarButtonItem(title: " 全不选 ", style: UIBarButtonItemStyle.Done, target: self, action: "unSelectAll")
    }()
    
    lazy var removeItem: UIBarButtonItem = {
        return UIBarButtonItem(title: " 删除 ", style: UIBarButtonItemStyle.Done, target: self, action: "remove")
    }()
    
    lazy var editItem: UIBarButtonItem = {
        [unowned self] in
        return UIBarButtonItem(title: self.editTitle, style: UIBarButtonItemStyle.Done, target: self, action: "edit:")
    }()
    
    lazy var deals: [SWDeal] = {
        return []
    }()
    
    lazy var noDataView: UIImageView = {
        [unowned self] in
        let v = UIImageView(image: UIImage(named: "icon_collect_empty"))
        self.view.addSubview(v)
        v.frame = self.collectionView!.backgroundView!.bounds
        v.hidden = true
        return v
    }()
    
    // 这是一个便利构造器
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(305, 305)
        
        let cols: CGFloat = (UIScreen.mainScreen().bounds.width == 1024) ? 3 : 2
        
        let inset = (UIScreen.mainScreen().bounds.width - cols * layout.itemSize.width) / (cols + 1)
        
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset)
        
        layout.minimumLineSpacing = inset
        
        self.init(collectionViewLayout: layout)        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.registerNib(UINib(nibName: "SWDealCell", bundle: nil), forCellWithReuseIdentifier: enshireReuseIdentifier)

        title = "收藏的团购"
        collectionView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        
        // 返回
        navigationItem.leftBarButtonItems = [backItem]
        
        // 监听收藏状态改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "collectStateChanged", name: SWCollectStateDidChangeNotification, object: nil)
        
        // 读取数据
        loadMoreDeals()
        
        // 添加上拉刷新
        collectionView?.alwaysBounceVertical = true
        collectionView?.addFooterWithTarget(self, action: "loadMoreDeals")
        
        navigationItem.rightBarButtonItems = [editItem]
    }
    
    func edit(sender: UIBarButtonItem) {
        if sender.title == editTitle {
            sender.title = doneTitle
            
            // 设置左侧导航栏出现按钮
            navigationItem.leftBarButtonItems = [backItem, selectAllItem, unselectAllItem, removeItem]
            
            // 设置cell进入编辑选项
            for deal in deals {
                deal.edit = true
            }
            
            removeItem.enabled = false
            
        } else {
            sender.title = editTitle
            
            navigationItem.leftBarButtonItems = [backItem]
            
            for deal in deals {
                deal.edit = false
            }
        }
        collectionView?.reloadData()
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectAll() {
        for deal in deals {
            deal.checking = true
        }
        collectionView?.reloadData()
        
        selectAllItem.enabled = false
        unselectAllItem.enabled = true
        removeItem.enabled = true
    }
    
    func unSelectAll() {
        for deal in deals {
            deal.checking = false
        }
        collectionView?.reloadData()
        
        unselectAllItem.enabled = false
        selectAllItem.enabled = true
        removeItem.enabled = false
    }
    
    func remove() {
        var needRemoveDeals = [SWDeal]()
        for deal in deals {
            if deal.checking {
                needRemoveDeals.append(deal)
                SWDealTool.shareInstance.removeCollectDeal(deal)
            }
        }
        
        // 删除当前数据源中的数据
        for willRemove in needRemoveDeals {
            let index = find(deals, willRemove)
            deals.removeAtIndex(index!)
        }
        
        removeItem.enabled = false
        
        collectionView?.reloadData()
        
        if collectionView?.numberOfItemsInSection(0) == 0 {
            selectAllItem.enabled = false
            unselectAllItem.enabled = false
        }
    }
    
    func loadMoreDeals() {
        // 修改页面
        curPage++
        
        // 增加数据
        deals += SWDealTool.shareInstance.collectDeals(curPage)
        
        // 刷新表格
        collectionView?.reloadData()
        
        // 结束刷新
        collectionView?.footerEndRefreshing()
    }
    
    func collectStateChanged() {
        curPage = 0
        
        deals.removeAll(keepCapacity: false)
        
        loadMoreDeals()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return deals.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(enshireReuseIdentifier, forIndexPath: indexPath) as! SWDealCell
    
        // Configure the cell
        cell.setDeal(deals[indexPath.row])
        cell.delegate = self
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SWDetailViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        vc.deal = deals[indexPath.row]
        presentViewController(vc, animated: true, completion: nil)
        
    }

}

extension SWEnshireController: SWDealCellDelegate {
    func dealCoverClick(sender: SWDealCell) {
    
        var hasChecking = false
        
        for deal in deals {
            if deal.checking {
                hasChecking = true
                break
            }
        }
        
        removeItem.enabled = hasChecking
    }
}
