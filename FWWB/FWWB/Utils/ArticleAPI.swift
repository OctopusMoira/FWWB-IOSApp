//
//  ArticleAPI.swift
//  FWWB
//
//  Created by jingyaoTang on 2019/3/23.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit
import Network
class ArticleAPI{
    var recognize_url: String = "http://fwwb.0x7cc.com/api/articles"
    var tips_url:String = "http://fwwb.0x7cc.com/api/articles/tips"
    var roll_url:String = "http://fwwb.0x7cc.com/api/articles/rollings"
    
}
extension ArticleAPI{
    open func getAllTips(url:String)->[TipsInfo]{
        let fullurl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let rurl = URL(string: fullurl!)
        var request = URLRequest(url: rurl!)
        request.httpMethod = "GET"
        var ret : [TipsInfo] = []
        print(url)
        let sem = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else{
                sem.signal()
                print("read error")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [Any] {
                for item in responseJSON{
                    guard let i = item as? [String:Any] else{
                        print("error to change")
                        sem.signal()
                        return
                    }
                    print("geting")
                    // print(i)
                    let r : TipsInfo = TipsInfo(title: i["title"] as! String, url: i["content"] as! String)
                    
                    ret.append(r)
                }
                sem.signal()
            }
        }
        task.resume()
        sem.wait()
        return ret
    }
    open func getAllArticles(url:String) -> [ArticleInfo]{
        let fullurl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let rurl = URL(string: fullurl!)
        var request = URLRequest(url: rurl!)
        request.httpMethod = "GET"
        var ret : [ArticleInfo] = []
        print(url)
        let sem = DispatchSemaphore.init(value: 0)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else{
                sem.signal()
                print("read error")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [Any] {
                for item in responseJSON{
                    guard let i = item as? [String:Any] else{
                        print("error to change")
                        sem.signal()
                        return
                    }
                    print("geting")
                   // print(i)
                    let r : ArticleInfo = ArticleInfo(title: (i["title"] as? String), author: i["author"] as? String, tag: (i["tag"] as? String), img: Utils.base64DecodeImage(i["cover"] as? String ?? "0"), content: i["content"] as? String, save:i["save"] as? Bool,id: i["article_id"] as? String)
                    
                    ret.append(r)
                }
                sem.signal()
            }
        }
        task.resume()
        sem.wait()
        return ret
    }
}
