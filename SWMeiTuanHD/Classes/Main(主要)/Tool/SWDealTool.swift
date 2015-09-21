//
//  SWDealTool.swift
//  SWMeiTuanHD
//
//  Created by integrated on 9/8/15.
//  Copyright (c) 2015 integrated. All rights reserved.
//

import UIKit

class SWDealTool: NSObject {

    private override init() {}
    
    class var shareInstance: SWDealTool {return instance}
    static let instance = SWDealTool()
    
    lazy var db: FMDatabase = {
        // 1.打开数据库
        let path: String? = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String])?.last?.stringByAppendingPathComponent("deal.sqlite")
        var _db = FMDatabase(path: path!)
        
        if _db.open() {
        
            // 2.创建表
            _db.executeUpdate("CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);")
            _db.executeUpdate("CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);")
        }

        return _db
    }()
    
    func collectDeals(page: Int) -> [SWDeal] {
        let size: Int = 20
        let pos: Int = (page - 1) * size
        
        let sql = "SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT ?, ?"
        let set = db.executeQuery(sql, withArgumentsInArray: [pos, size])
        var result = [SWDeal]()
        while set!.next() {
            let data = set!.dataForColumn("deal")
            let A = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SWDeal
            result.append(A)
        }
        return result
    }
    
    func recentDeals(page: Int) -> [SWDeal] {
        let size: Int = 20
        let pos: Int = (page - 1) * size
        
        let sql = "SELECT * FROM t_recent_deal ORDER BY id DESC LIMIT ?, ?"
        let set = db.executeQuery(sql, withArgumentsInArray: [pos, size])
        var result = [SWDeal]()
        while set!.next() {
            let data = set!.dataForColumn("deal")
            let A = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SWDeal
            result.append(A)
        }
        return result
    }
    
    func addCollectDeal(deal: SWDeal) {
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(deal)
        let sql = "INSERT INTO t_collect_deal(deal, deal_id) VALUES(?, ?)"
        let suc = db.executeUpdate(sql, withArgumentsInArray: [data, deal.deal_id])
    }
    
    func addRecentDeal(deal: SWDeal) {
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(deal)
        let sql = "INSERT INTO t_recent_deal(deal, deal_id) VALUES(?, ?)"
        let suc = db.executeUpdate(sql, withArgumentsInArray: [data, deal.deal_id])
    }
    
    func removeCollectDeal(deal: SWDeal) {
        db.executeUpdate("DELETE FROM t_collect_deal WHERE deal_id = '\(deal.deal_id)';")
    }
    
    func removeRecentDeal(deal: SWDeal) {
        db.executeUpdate("DELETE FROM t_recent_deal WHERE deal_id = '\(deal.deal_id)';")
    }
    
    func isCollected(deal: SWDeal) -> Bool {
        let sql = "SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = ?;"
        let set = db.executeQuery(sql, withArgumentsInArray:[deal.deal_id])
        if set == nil {
            return false
        }
        set!.next()
        return set!.intForColumn("deal_count") == 1
    }
    
    func collectDealsCount() -> Int {
        
        let set = db.executeQuery("SELECT count(*) AS deal_count FROM t_collect_deal;")
        set!.next()
        return Int(set!.intForColumn("deal_count"))
    }
    
}
