//
//  String+Extension.swift
//  SWMeiTuanHD
//
//  Created by integrated on 8/25/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}
