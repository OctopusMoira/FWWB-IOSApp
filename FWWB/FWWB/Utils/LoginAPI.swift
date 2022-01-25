//
//  LoginAPI.swift
//  Login
//
//  Created by jingyaoTang on 2019/3/19.
//  Copyright © 2019 jingyaoTang. All rights reserved.
//

import UIKit
import Network
class LoginAPI{
    var recognize_url: String = "http://fwwb.0x7cc.com/api/sessions"
    var collect_url: String = "http://fwwb.0x7cc.com/api/save"
    
}

extension LoginAPI{
    open func recognizeLogin(url:String,data: NSMutableDictionary) -> String?{
        let jsonData = makePostCall(rawurl: url, params: data)
        if jsonData == nil {
            print("nil")
            return nil
            
        }
        let jsonDecoder = JSONDecoder()
        var responseJson: Textresponse? = nil
        do {
            responseJson = try jsonDecoder.decode(Textresponse.self, from: jsonData!)
        } catch {
            print("json parsing fail")
            print("error: \(error).")
            print("raw data:" + String(data: jsonData!, encoding: .utf8)!)
            return nil
        }
        if responseJson?.session_id == nil{
            return nil
        }
        return responseJson?.session_id
    }
    
}
extension LoginAPI{
    private func makePostCall(rawurl: String,params:NSDictionary) -> Data?{
        guard let url = URL(string: rawurl) else {
            print("Error: cannot create url")
            return nil
        }
        print(url)
        // 请求
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data : NSData! = try? JSONSerialization.data(withJSONObject: params, options: []) as NSData
        let JSONString = String(data:data as Data, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        urlRequest.httpBody = JSONString?.data(using: .utf8)
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
