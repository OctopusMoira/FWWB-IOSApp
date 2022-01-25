//
//  Head.swift
//  Foot_Print
//
//  Created by jingyaoTang on 2019/1/19.
//  Copyright © 2019 jingyaoTang. All rights reserved.
//

import UIKit

struct Head{
    
    let title: String
    //inner info
    
    init(title :String){
        self.title = title
    }
    
    static func headsFromBundle() -> Head{
        
        let head = Head(title: "123")
        
        guard let url = Bundle.main.url(forResource: "Footheads", withExtension: "json") else {
            return head
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]  else {
                return head
            }
            guard let headObjects = rootObject["head"] as? [[String: AnyObject]] else {
                return head
            }
            
            for headObject in headObjects{
                
               if let ti = headObject["title"] as? String{
                    
                    let head = Head(title: ti)
                        return head
                }
            }
            
        } catch {
            return head
        }
        
        return head
        
    }
    
}
