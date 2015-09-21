//
//  SWMapController.swift
//  SWMeiTuanHD
//
//  Created by integrated on 9/12/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit
import MapKit

class SWMapController: UIViewController {

    @IBOutlet private var mapView: MKMapView!
    
    lazy var backItem: UIBarButtonItem = {
        [unowned self] in
        return UIBarButtonItem(target: self, action: "back", imageUrl: "icon_back", selectImageUrl: "icon_back_highlighted")
    }()
    
    lazy var categoryItem: UIBarButtonItem = {
        var categoryV = SWTopItem(frame: CGRectMake(0, 0, 140, 35))
        categoryV.addTarget(self, action: "categoryClicked")
        categoryV.setIcon("icon_district", highlightedImageUrl: "icon_district_highlighted")
        return UIBarButtonItem(customView: categoryV)
    }()
    
    /** 解码 */
    lazy var coder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    private var categoryPopover: UIPopoverController!
    
    private var annotations: [SWAnnotation] = []
    
    private var locationManage: CLLocationManager!
    
    private var city: String!
    
    private var category: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "地图"
        
        // 返回键
        navigationItem.leftBarButtonItems = [backItem, categoryItem]
        
        // 监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "categoryDidChange:", name: SWCategoryDidChangeNotification, object: nil)
        
        locationManage = CLLocationManager()
        locationManage.delegate = self
        locationManage.requestAlwaysAuthorization()
        locationManage.startUpdatingLocation()
        
        // 设置地图跟踪用户位置改变
        mapView.userTrackingMode = MKUserTrackingMode.Follow
    }
    
    override func loadView() {
        super.loadView()
        NSBundle.mainBundle().loadNibNamed("SWMapController", owner: self, options: nil)
        
    }
    
    func categoryDidChange(notification: NSNotification) {
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if let sub = notification.userInfo?[SWSelectedSubCategory] as? String {
            category = sub
        } else {
            category = notification.userInfo?[SWSelectedCategory] as? String
        }
        
        mapView(self.mapView, regionDidChangeAnimated: true)
        
        // 设置顶部文字
    }
    
    func categoryClicked() {
        // 显示分类菜单
        
        self.categoryPopover = UIPopoverController(contentViewController: SWCategoryViewController())
        self.categoryPopover!.presentPopoverFromBarButtonItem(categoryItem, permittedArrowDirections: .Any, animated: true)
    }
    
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - CLLocationManagerDelegate

extension SWMapController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        println(locations.last)
    }
}


// MAKR: - MKMapViewDelegate

extension SWMapController: MKMapViewDelegate {
    
    // 用户位置更新时调用(第一次定位)
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        // 1.设置显示区域大小
        
        let lo = CLLocationCoordinate2D(latitude: 22.599486, longitude: 113.086661)
        
        println("latitude \(userLocation.location.coordinate.latitude)")
        println("longitude \(userLocation.location.coordinate.longitude)")

        
        let region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.2, 0.2))
        self.mapView.setRegion(region, animated: false)
        
        coder.reverseGeocodeLocation(userLocation.location, completionHandler: { [unowned self] (list, error) -> Void in
            let placeArray = list as? [CLPlacemark]
            
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
            println(placeMark.addressDictionary)

            // 这个是城市
            if let locationCity = placeMark.addressDictionary["City"] as? NSString{
                println(locationCity)
                self.city = locationCity.substringToIndex(locationCity.length - 1)
            }
            
            // 省份
            if let locationState = placeMark.addressDictionary["State"] as? NSString{
                println(locationState)
//                self.city = locationState.substringToIndex(locationState.length - 1)
            }
            
            self.mapView(mapView, regionDidChangeAnimated: true)
        })
        
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        
        // TODO : - 用户区域发生改变的时候，重新发生请求
        if city == nil { return }
        
        let api = DPAPI()
        var params: NSMutableDictionary = ["city": city]
        if category != nil {
            params["category"] = category
        }
        
        params["latitude"] = String("\(mapView.region.center.latitude)")
        params["longitude"] = String("\(mapView.region.center.longitude)")
        params["radius"] = "5000"
        
        api.requestWithURL("v1/deal/find_deals", params: params, delegate: self)
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKAnnotation.Type {
        } else {
            return MKAnnotationView()
        }
        
        let id = "dealId"
        var anno = mapView.dequeueReusableAnnotationViewWithIdentifier(id)
        if anno == nil {
            anno = MKAnnotationView(annotation: nil, reuseIdentifier: id)
            anno.canShowCallout = true
        }
        
        anno.annotation = annotation
        
        anno.image = UIImage(named: (annotation as! SWAnnotation).icon)
        
        return anno
    }
}

extension SWMapController: DPRequestDelegate {
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {

        var totalCount: Int = Int()
        var deals: [SWDeal] = []
        
        // 获得团购
        if let resutDict = result as? Dictionary<String, AnyObject>, total_count = resutDict["count"] as? Int {
            totalCount = total_count
            if let resultDict = result as? Dictionary<String, AnyObject>, dealsArray = resultDict["deals"] as? Array<Dictionary<String, AnyObject>> {
                for index in 0..<totalCount {
                    deals.append(SWDeal(dictionary: dealsArray[index]))
                }
            }
        }
        
        let annos:[MKAnnotation] = {
            [unowned self] in
            return self.mapView.annotations as! [MKAnnotation]
        }()
            
        // 团购所属类型
        for deal in deals {
            let category = SWDataTool.sharedInstance.getCategoryWithDeal(deal)
            
            for business in deal.businesses {
                let anno: SWAnnotation
                if let icon = category?.map_icon {
                    anno = SWAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(business.latitude), longitude: Double(business.longitude)), title: business.name, deal.title, icon)
                } else {
                    anno = SWAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(business.latitude), longitude: Double(business.longitude)), title: business.name, deal.title)
                }
                
                if contains(mapView.annotations as! [SWAnnotation], anno) {
                
                } else {
                    mapView.addAnnotation(anno)
                }
            }
        }

    }
    
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        MBProgressHUD.showError("网络繁忙，请稍后再试")
        println(error)
    }
}

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
