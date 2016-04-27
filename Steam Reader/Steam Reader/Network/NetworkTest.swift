//
//  NetworkTest.swift
//  Steam Reader
//
//  Created by Kyle Roberts on 4/27/16.
//  Copyright © 2016 Kyle Roberts. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkTest: NSObject {
    var key: NSString?
    
    func getRecentGames() {
        do {
            let path = NSBundle.mainBundle().pathForResource("SteamKey", ofType: "")
            self.key = try NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch {
            print("Error getting key from SteamKey file.")
        }
        
        Alamofire.request(.GET, "https://store.steampowered.com/api/featured/")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
//                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        Alamofire.request(.GET, "https://api.steampowered.com/ISteamApps/GetAppList/v0002/", parameters: ["key" : key!])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                var games: [JSON] = []
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    for (_, subJson):(String, JSON) in json["applist", "apps"] {
                        print(subJson["name"].stringValue)
                        if subJson["name"].stringValue == "The Long Dark" {
                            games.append(subJson)
                        }
                    }
                }
                
                print(games)
        }
        
        Alamofire.request(.GET, "https://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/", parameters: ["key" : key!, "appid" : 305620])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                var news: [JSON] = []
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    for (_, subJson):(String, JSON) in json["appnews", "newsitems"] {
                        news.append(subJson)
                    }
                }
                
                print(news)
        }
    }
}
