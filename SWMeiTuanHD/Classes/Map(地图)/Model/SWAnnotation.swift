//
//  SWAnnotation.swift
//  SWMeiTuanHD
//
//  Created by integrated on 9/16/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit
import MapKit


class SWAnnotation: NSObject {
    
    let _coordinate: CLLocationCoordinate2D
    
    let _title: String
    
    let _subtitle: String
    
    let icon: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, _ subtitle: String = "", _ icon: String = "") {
        self._coordinate = coordinate
        self._title = title
        self._subtitle = subtitle
        self.icon = icon
        
        super.init()
    }
}

extension SWAnnotation: MKAnnotation{
    var coordinate: CLLocationCoordinate2D {
        get {
            return self._coordinate
        }
    }
    
    var title: String! {
        get {
            return self._title
        }
    }
    
    var subtitle: String! {
        get {
            return self._subtitle
        }
    }
}
