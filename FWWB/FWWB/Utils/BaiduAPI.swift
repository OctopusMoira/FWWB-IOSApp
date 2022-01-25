//
//  BaiduAPI.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/14.
//  Copyright © 2019 fwwb. All rights reserved.
//

import Foundation


class BaiduAPI{
    let url = "https://api.map.baidu.com/place/v2/search?&output=json&ak="
    let key = "ADHXFu4RedkYCHAHTA9KEZnljfLZIvTK"
    var raw_url : String{
        return url + key
    }
    enum Tag : Int{
        case View = 0
        case Restaurant = 1
        case Hotel = 2
    }
    //query=ATM机&tag=银行&region=北京
    let defaulttags = ["旅游景点","美食","酒店"]
    
    open func getQueryResult(query: String,tag: Tag,region: String) -> [Any]?{
        let query = "&query="+query+defaulttags[tag.rawValue]
        let tag = "&tag="+defaulttags[tag.rawValue]
        let region = "&region="+region
        let rurl = raw_url + query + tag + region
        
        print(rurl)
        let uurl = URL(string: (rurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
        var request = URLRequest(url: uurl!)
        request.httpMethod = "GET"
        var ret : [Any]? = nil
        let sem = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else{
                sem.signal()
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard let items = responseJSON["results"] as? [Any] else{
                    sem.signal()
                    return
                }
                sem.signal()
                ret = items
            }
        }
        task.resume()
        sem.wait()
        return ret
    }
    
    public func translate(content: String,nationality: Bool) -> String{
        
        let appid : String = "20160404000017508"
        let secrtkey : String = "P7KflEZwz1LfVqaPdtih"
        
        let languagedic = ["中文":"zh","日文":"jp"]
        var from : String = languagedic["中文"]!
        var to : String = languagedic["日文"]!
        
        switch nationality {
        case true:
            from = languagedic["日文"]!
            to = languagedic["中文"]!
        case false:
            from = languagedic["中文"]!
            to = languagedic["日文"]!
        }
        
        let q : String = content
        
        let salt = "123"
        
        let rawsign = appid+q+salt+secrtkey
        let sign = MD5(rawsign)
        
        let rawurl : String = "https://fanyi-api.baidu.com/api/trans/vip/translate"
        var urlArg : String = "q=" + q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&from=" + from + "&to=" + to
        urlArg = urlArg + "&appid=" + appid + "&salt=" + salt + "&sign=" + sign!
        
        let url = URL(string: rawurl+"?"+urlArg)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sem = DispatchSemaphore.init(value: 0)
        var ret : String = ""
        let task = URLSession.shared.dataTask(with: request){ data,respons,error in
            guard let data = data ,error == nil else{
                sem.signal()
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard let items = responseJSON["trans_result"] as? [Any] else{
                    sem.signal()
                    return
                }
                guard let lan = items[0] as? [String:String] else{return}
                ret = lan["dst"]!
                sem.signal()
            }else{
                sem.signal()
                return
            }
        }
        task.resume()
        sem.wait()
        return ret
    }
    
    
    
}
