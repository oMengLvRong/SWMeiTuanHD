//
//  SWDetailViewController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 8/26/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWDetailViewController: UIViewController {
    
    var deal: SWDeal!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var desLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var leftTimeBtn: UIButton!
    
    @IBOutlet var collectButton: UIButton!
    
    @IBOutlet var supportAnyTimeBtn: UIButton!
    
    @IBOutlet var supportOutTImeBtn: UIButton!
    
    @IBAction func backTouchUpInside(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buyTouchUpInside(sender: UIButton) {
//        // 1. 生成订单信息
//        let order = AlixPayOrder()
//        order.productName = deal.title
//        order.productDescription = deal.desc
//        order.partner = PartnerID
//        order.seller = SellerID
//        order.amount = deal.current_price
//        
//        // 2. 签名加密
//        let signer = CreateRSADataSigner(PartnerPrivKey)
//        let signedString = signer.signString(order.description)
//        
//        // 3. 利用订单信息，签名信息签名类型生成一个字符串
//        let orderString = NSString(format: "%@&sign=\"%@\"&sign_type=\"%@\"", order.description, signedString, "RSA")
//        
//        // 4. 打开客户端，进行支付
//        AlixLibService.payOrder(orderString as String, andScheme: "tuangou", seletor: "getResult:", target: self)
    }
    
    @IBAction func CollectTouchUpInside(sender: UIButton) {
        
        if sender.selected { // 取消收藏
            MBProgressHUD.showSuccess("取消收藏成功")
            
            SWDealTool.shareInstance.removeCollectDeal(deal)
            
        } else { // 收藏
            MBProgressHUD.showSuccess("收藏成功")
            
            SWDealTool.shareInstance.addCollectDeal(deal)
        }
        
        sender.selected = !sender.selected
        
    }
    func getResult() {
        
    }
    
    override func loadView() {
        super.loadView()
        NSBundle.mainBundle().loadNibNamed("SWDetailViewController", owner: self, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        // 1.加载页面
        webView.hidden = true
        webView.loadRequest(NSURLRequest(URL: NSURL(string: deal.deal_h5_url)!))
        
        // 2.设置基本信息
        titleLabel.text = deal.title
        desLabel.text = deal.desc
        imageView.sd_setImageWithURL(NSURL(string: deal.image_url), placeholderImage: UIImage(named: "placeholder_deal"))
        
        // 3.设置剩余天数
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        var dead = fmt.dateFromString(deal.purchase_deadline)
        
        // 追加一天
        dead = dead?.dateByAddingTimeInterval(24 * 60 * 60)
        let now = NSDate()
        let unit = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
        let cmps = NSCalendar.currentCalendar().components(unit, fromDate: now, toDate: dead!, options: NSCalendarOptions.allZeros)
        if cmps.day > 365 {
            leftTimeBtn.setTitle("一年之内不过期", forState: .Normal)
        } else {
            leftTimeBtn.setTitle("\(cmps.day)天\(cmps.hour)小时\(cmps.minute)分钟", forState: .Normal)
        }
        
        // 4.发送请求获取更详细的团购数据
        let api = DPAPI()
        var params = NSMutableDictionary()
        params["deal_id"] = deal.deal_id
        api.requestWithURL("v1/deal/get_single_deal", params: params, delegate: self)
        
        // 5.设置收藏状态
        collectButton.selected = SWDealTool.shareInstance.isCollected(deal)
        
        // 6.发送最近浏览deal改变事件
        NSNotificationCenter.defaultCenter().postNotificationName(SWRecentStateDidChangedNotification, object: nil)
        SWDealTool.shareInstance.addRecentDeal(deal)
    }

}

// MARK: - 控制只支持横评

extension SWDetailViewController {
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
}

// MARK: - DPRequestDelegate

extension SWDetailViewController: DPRequestDelegate {
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        println(result)
        if let r = result as? Dictionary<String,AnyObject>, e = r["deals"] as? Array<Dictionary<String, AnyObject>>, s = e.first {
            deal = SWDeal(dictionary: s)
        }
        
        supportAnyTimeBtn.selected = deal.restrictions.is_refundable == 1 ? true : false
        supportOutTImeBtn.selected = deal.restrictions.is_reservation_required == 1 ? true : false
    }
    
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        MBProgressHUD.showError("网络繁忙，请稍后再试", toView: view)
    }
}

// MARK: - UIWebViewDelegate

extension SWDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        
        if webView.request?.URL?.absoluteString! == deal.deal_h5_url { // 旧的HTML5页面加载完毕
            let ID = deal.deal_id.componentsSeparatedByString("-")[1]
            let urlStr = "http://lite.m.dianping.com/group/deal/moreinfo/" + ID
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)!))
        } else { // 处理详情页
            var js = NSMutableString()
            
            // 删除header
            js.appendString("var header = document.getElementsByTagName('header')[0];")
            js.appendString("header.parentNode.removeChild(header);")
            
            // 删除顶部的购买
            js.appendString("var box = document.getElementsByClassName('cost-box')[0];")
            js.appendString("box.parentNode.removeChild(box);")
            
            // 删除底部的购买
            js.appendString("var buyNow = document.getElementsByClassName('buy-now')[0];")
            js.appendString("buyNow.parentNode.removeChild(buyNow);")
            
            webView.stringByEvaluatingJavaScriptFromString(js as String)
            
            // 停止转动
            activityIndicator.stopAnimating()
            webView.hidden = false
        }
    }
}





























