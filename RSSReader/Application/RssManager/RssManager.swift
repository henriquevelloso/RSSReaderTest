//
//  RssManager.swift
//  BraviTest
//
//  Created by Henrique Velloso on 18/05/17.
//
//

import UIKit
import Alamofire
import AlamofireRSSParser
import PromiseKit

class RssManager: NSObject {
    
    class func insertFeedSource(name:String, url:String) {
        
        var feedSource = [String:String]()
        
        if let data = UserDefaults.standard.object(forKey: "feedSource") as? NSData {
            feedSource = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [String:String]
            feedSource[name] = url
            
            let newData = NSKeyedArchiver.archivedData(withRootObject: feedSource)
            UserDefaults.standard.set(newData, forKey: "feedSource")
            
        } else {
            
            feedSource[name] = url
            let newData = NSKeyedArchiver.archivedData(withRootObject: feedSource)
            UserDefaults.standard.set(newData, forKey: "feedSource")
            
        }
    }
    
    class func removeFeedSource(name:String) {
        
        var feedSource = [String:String]()
        
        if let data = UserDefaults.standard.object(forKey: "feedSource") as? NSData {
            feedSource = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [String:String]
            
            feedSource.removeValue(forKey: name)
            
            let newData = NSKeyedArchiver.archivedData(withRootObject: feedSource)
            UserDefaults.standard.set(newData, forKey: "feedSource")
            
        }
    }
    
    class func getFeedSource() -> [String:String] {
        
        var feedSource = [String:String]()
        
        if let data = UserDefaults.standard.object(forKey: "feedSource") as? NSData {
            feedSource = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [String:String]
        }
        
        return feedSource
        
    }
    
    class func loadItemsFromUrl(url:String) -> Promise<[RSSItem]> {
        
        return Promise { fulfill, reject in
        
            Alamofire.request(url).responseRSS { (response) in
                
                if let feed: RSSFeed = response.result.value {
                    fulfill(feed.items)
                } else {
                    reject(response.error!)
                }
            }
        }
    }
    
    
    
    class func loadItemsFromAllFeedSource() -> Promise<[RSSItem]> {
        
        let feedSource = RssManager.getFeedSource()
        var rssItems = [RSSItem]()
        
        
        return Promise { fulfill, reject in
            
            var completedRequests = 0
            for source in feedSource {
                
                Alamofire.request(source.value).responseRSS { (response) in
                    
                    if let feed: RSSFeed = response.result.value {
                        rssItems.append(contentsOf: feed.items)
                        
                        for item in feed.items {
                            item.source = source.key
                        }
                        
                        completedRequests += 1
                        
                        if completedRequests == feedSource.count {
                            
                            rssItems = rssItems.sorted(by: {$0.0.pubDate! > $0.1.pubDate!})
                            fulfill(rssItems)
                        }
                        
                    } else {
                        // reject(response.error!)
                    }
                }
            }
            
            
        }
    }
    

    

}
