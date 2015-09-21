//
//  SWDealCell.swift
//  SWMeiTuanHD
//
//  Created by integrated on 8/24/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

protocol SWDealCellDelegate: class {
    func dealCoverClick(sender: SWDealCell) -> Void
}

class SWDealCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var curPriceLabel: UILabel!
    
    @IBOutlet var realPriceLabel: UILabel!
    
    @IBOutlet var purchaseCountLabel: UILabel!
    
    @IBOutlet var newDealView: UILabel!
    
    @IBOutlet var cover: UIButton!
    
    @IBOutlet var selectSign: UIImageView!
    
    @IBAction func coverTouchUpInside(sender: UIButton) {
        
        println(_deal)
        
        self._deal!.checking = selectSign.hidden
        
        selectSign.hidden = !selectSign.hidden
        
        delegate?.dealCoverClick(self)
    }
    
    weak var _deal: SWDeal?
    
    weak var delegate: SWDealCellDelegate?
    
    func setDeal(deal: SWDeal) {
        
        _deal = deal
        
        // 设置图片
        imageView.sd_setImageWithURL(NSURL(string: deal.s_image_url), placeholderImage: UIImage(named: "placeholder_deal"))
        
        // 设置标题
        titleLabel.text = deal.title
        
        // 设置描述
        descriptionLabel.text = deal.desc
        
        // 购买数
        purchaseCountLabel.text = String("已售\(deal.purchase_count)")
        
        // 现价
        if contains(deal.current_price, ".") {
            let docLoc = NSString(string: deal.current_price).rangeOfString(".").location
            curPriceLabel.text = String("¥ \(deal.current_price[0...(Int(docLoc)+1)])")
        } else {
             curPriceLabel.text = String("¥ \(deal.current_price)")
        }
        
        // 原价
        let realPrice = String("¥ \(deal.list_price)")
        let attributed = [NSStrikethroughStyleAttributeName: 1]
        let attributedString = NSMutableAttributedString(string: realPrice, attributes: attributed)
        
        realPriceLabel.attributedText = attributedString
        
        // 是否显示新单图片
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let dateString = fmt.stringFromDate(NSDate())
        
        newDealView.hidden = (NSString(string: deal.publish_date).compare(dateString) == NSComparisonResult.OrderedAscending)
        
        cover.hidden = !deal.edit
        
        selectSign.hidden = !deal.checking
    }
}
