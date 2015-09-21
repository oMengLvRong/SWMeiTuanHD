//
//  SWDropdownSubCell.swift
//  SWMeiTuanHD
//
//  Created by integrated on 7/29/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWDropdownSubCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // setup
        self.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
        self.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 公有方法
    
    class func cellWithTableView(tableView : UITableView) -> SWDropdownMainCell {
        
        let id = "sub"
        var cell = tableView.dequeueReusableCellWithIdentifier(id) as? SWDropdownMainCell
        
        if cell == nil {
            cell = SWDropdownMainCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: id)
        }
        
        return cell!
    }

}
