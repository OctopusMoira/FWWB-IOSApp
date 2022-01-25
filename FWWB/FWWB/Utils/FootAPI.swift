//
//  FootAPI.swift
//  FWWB
//
//  Created by jingyaoTang on 2019/3/23.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit
import Network
class FootAPI{
    var recognize_url: String = "http://fwwb.0x7cc.com/api/sessions"
    var collect_url: String = "http://fwwb.0x7cc.com/api/save"
    var footGet_url:String = "http://fwwb.0x7cc.com/api/footprints"
}

extension FootAPI{
    
open func FootPostCall(rawurl: String, params:  NSDictionary)->Data?{
        guard let url = URL(string: rawurl) else {
            print("Error: cannot create url")
            return nil
        }
        print(url)
        // 2. 请求(可以改的请求)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
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

 open func recognizeLogin(url:String) -> footResults?{
        let jsonData = makeGetCall(rawurl: url)
        if jsonData == nil {
            print("nil")
            return nil
            
        }
        let jsonDecoder = JSONDecoder()
        var responseJson: Footresponses
        do {
            responseJson = try jsonDecoder.decode(Footresponses.self, from: jsonData!)
        } catch {
            print("json parsing fail")
            print("error: \(error).")
            print("raw data:" + String(data: jsonData!, encoding: .utf8)!)
            return nil
        }
         var nodes = [footResult]()
         for node in responseJson.nodes{
         let result = footResult(
            location: node.location, date:node.date,time:node.time, comment:node.comment,longitude:node.longitude, latitude:node.latitude, image:node.image
                )
            nodes.append(result)
            }
        let Result = footResults(headname:responseJson.name,footNodes:nodes)
        return Result
    }
   }
extension FootAPI{
    private func makeGetCall(rawurl: String) -> Data?{
        guard let url = URL(string: rawurl) else {
            print("Error: cannot create url")
            return nil
        }
        print(url)
        print("Get fail")
        // 请求
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        
        var responseData: Data?
        
        let sem = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            print(error ?? "error")
            guard error == nil else {
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
