//
//  SWCollectionViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 8/24/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

let reuseIdentifier = "SWDealCell"

protocol SWCollectionViewControllerDelegate: class {
    /** 这个方法留给子类去重写 */
    func setParams(inout params: NSMutableDictionary)
}

class SWCollectionViewController: UICollectionViewController {
    
    // MARK: - Getter & Setter
    
    /** 所有的团购数据 */
    var deals: [SWDeal] = []
    
    /** 没有数据时显示的图片 */
    let nodataView: UIImageView = UIImageView()
    
    /** 记录当前页码 */
    var currentPage: Int = 1
    
    /** 总数 */
    var totalCount: Int = 0
    
    /** 最后一个请求 */
    var lastRequest: DPRequest!
    
    weak var delegate: SWCollectionViewControllerDelegate?
    
    // MARK: - Life Cycle
    
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

    // 因为如果我们自定义了一个指定构造器，所以父类的指定构造器并不会自动继承，因此这个required的指定构造器需要我们自己定制
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let cols: CGFloat = (size.width == 1024) ? 3 : 2
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let inset = (size.width - cols * layout.itemSize.width) / (cols + 1)
        
        layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset)
        
        layout.minimumLineSpacing = inset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color
        collectionView?.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.00)

        // Register cell classes
        collectionView?.registerNib(UINib(nibName: "SWDealCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.alwaysBounceVertical = true
        
        // Add Refresh
        collectionView?.addHeaderWithTarget(self, action: Selector("loadNewDeals"))
        collectionView?.addFooterWithTarget(self, action: Selector("loadMoreDeals"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UICollectionViewDataSource 代理事件

extension SWCollectionViewController: UICollectionViewDataSource {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return deals.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SWDealCell
        
        // Configure the cell
        cell.setDeal(deals[indexPath.row])
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate 代理事件

extension SWCollectionViewController: UICollectionViewDelegate {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = SWDetailViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        vc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        vc.deal = deals[indexPath.row]
        presentViewController(vc, animated: true, completion: nil)
    }
}


// MARK: - 美团－请求数据方法

extension SWCollectionViewController {
    
    func loadNewDeals() {
        currentPage = 1
        loadDeals()
    }
    
    func loadMoreDeals() {
        currentPage++
        loadDeals()
    }
    
    func loadDeals() {
        let api = DPAPI()
        
        var params: NSMutableDictionary = NSMutableDictionary()
        
        if let delegate = self.delegate {
            delegate.setParams(&params)
        }
        
        println(params)
        
        // 每页条数
        params["limit"] = "30"
        
        // 当前页码
        params["page"] = String(currentPage)
        
        lastRequest = api.requestWithURL("v1/deal/find_deals", params: params, delegate: self)
    }
}

// MARK: - DPRequestDelegate 代理事件

extension SWCollectionViewController: DPRequestDelegate {
    
    // 返回的是json数据
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        if request != lastRequest {
            return
        }
        
        if let resutDict = result as? Dictionary<String, AnyObject> {
            let total_count = resutDict["count"] as! Int
            totalCount = total_count
        }
        
        // 1.取出团购数据
        var newDeals: [SWDeal] = []
//        if let resultDict = result as? Dictionary<String, AnyObject> {
//            if let dealsArray = resultDict["deals"] as? Array<Dictionary<String, AnyObject>> {
//                for index in 0..<totalCount {
//                    let deal = SWDeal.objectWithKeyValues(dealsArray[index])
//                    if let desc = dealsArray[index]["description"] as? String {
//                        deal.desc = desc
//                    }
//                    newDeals.append(deal)
//                }
//            }
//        }
        
        if let resultDict = result as? Dictionary<String, AnyObject>, dealsArray = resultDict["deals"] as? Array<Dictionary<String, AnyObject>> {
            for index in 0..<totalCount {
                newDeals.append(SWDeal(dictionary: dealsArray[index]))
            }
        }
        if currentPage == 1 { // 清除之前的旧数据
            deals = []
        }
        deals += newDeals
        
        // 2.刷新表格
        collectionView?.reloadData()
        
        // 3.结束刷新
        collectionView?.footerEndRefreshing()
        collectionView?.headerEndRefreshing()
    }
    
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        if request != lastRequest {
            return
        }
        
        MBProgressHUD.showError("网络繁忙，请稍后在试", toView: view)
        
        collectionView?.footerEndRefreshing()
        collectionView?.headerEndRefreshing()
        
        // 如果是上拉失败了
        if currentPage > 1 {
            currentPage--
        }
        
        println(error)
    }
}
