//
//  GoogleVisionAPI.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/1.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit


class GoogleVisionApi{
    var apiUrl: String = "https://vision.googleapis.com/v1/images:annotate?alt=json&key="
    var kgsearchUrl: String = "https://kgsearch.googleapis.com/v1/entities:search?key="
    var apiKey: String = "AIzaSyCzJwMnszvosPRokR1dlpf-_8IBPYbO1LI"
    
    var recognize_url: String {
        return "https://automl.googleapis.com/v1beta1/projects/fwwb-229019/locations/us-central1/models/ICN8467934685368433561:predict"
        //return apiUrl + apiKey
    }
}

extension GoogleVisionApi{
    // 图片获取
    open func getimageUrl(ids: String){
        
    }
    // 地标识别
    open func recognizeLandmark(data: String) -> Array<ImageRecognizeResult>? {
        let jsonData = makePostCall(rawurl: recognize_url, data: data)
        if jsonData == nil {
            return nil
        }
        let jsonDecoder = JSONDecoder()
        var responseJson: Responses
        do {
            responseJson = try jsonDecoder.decode(Responses.self, from: jsonData!)
        } catch {
            print("json parsing fail")
            print("error: \(error).")
            print("raw data:" + String(data: jsonData!, encoding: .utf8)!)
            return nil
        }
        var results = [ImageRecognizeResult]()
        let responses = responseJson.responses
        for response in responses {
            for landmarkAnnotion in response.landmarkAnnotations {
                let result = ImageRecognizeResult(landmark: landmarkAnnotion.description, city: "",imgUrl: landmarkAnnotion.mid!)
                results.append(result)
            }
        }
        return results
    }
    // 文字识别
    open func recognizeText(data: String) -> String?{
        let jsonData = makePostCall(rawurl: recognize_url, data: data)
        if jsonData == nil {
            return nil
        }
        let jsonDecoder = JSONDecoder()
        var responseJson: TextResponses? = nil
        do {
            responseJson = try jsonDecoder.decode(TextResponses.self, from: jsonData!)
        } catch {
            print("json parsing fail")
            print("error: \(error).")
            print("raw data:" + String(data: jsonData!, encoding: .utf8)!)
            return nil
        }
        if responseJson?.responses[0].fullTextAnnotation == nil{
            return nil
        }
        return responseJson?.responses[0].fullTextAnnotation!.text
    }
}


extension GoogleVisionApi{
    // POST请求
    private func makePostCall(rawurl: String,data: String? = "") -> Data?{
        guard let url = URL(string: rawurl) else {
            print("Error: cannot create url")
            return nil
        }
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data?.data(using: .utf8)
        
        let session = URLSession.shared
        
        var responseData: Data?
        
        let sem = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            print(error)
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
