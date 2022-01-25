//
//  RecognizationSaveApi.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/24.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

class RecognizationSaveApi{
    let url = "http://fwwb.0x7cc.com/api/recognizations?session_id="
    var sessionid = ""
    var rawurl: String{
        return url + sessionid
    }
    
    public func save(data: Dictionary<String, String>,sessionid: String){
        self.sessionid = sessionid
        let response = makePostCall(rawurl: rawurl, params: data)
        print(response)
    }
    
    public func get(sessionid: String) -> [RecSaved]{
        self.sessionid = sessionid
        
        let fullurl = rawurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let rurl = URL(string: fullurl!)
        
        var request = URLRequest(url: rurl!)
        
        request.httpMethod = "GET"
        var ret: [RecSaved] = []
        
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
                    if let titem = item as? [String:String]{
                        let rec = RecSaved(title: titem["result"]!, img: Utils.base64DecodeImage(titem["image"]!), time: "2019-01-01")
                        ret.append(rec)
                    }
                }
                
                sem.signal()
            }else{
                sem.signal()
            }
        }
        task.resume()
        sem.wait()
        return ret
    }
    
    
}


extension RecognizationSaveApi{
    private func makePostCall(rawurl: String,params:Dictionary<String,String>) -> Data?{
        guard let url = URL(string: rawurl) else {
            print("Error: cannot create url")
            return nil
        }
        print(url)
        // 2. 请求(可以改的请求)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data : NSData! = try? JSONSerialization.data(withJSONObject: params, options: []) as NSData
        let JSONString = String(data:data as Data, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        urlRequest.httpBody = JSONString?.data(using: .utf8)
        
        var responseData: Data?
        
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        
            guard error == nil else {
                print(error!)
                sem.signal()
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
            }
            responseData = data
            if responseData == nil {
                print("Error: did not receive data")
                sem.signal()
                return
            }
            sem.signal()
        }
        task.resume()
        sem.wait()
        return responseData
    }
}
