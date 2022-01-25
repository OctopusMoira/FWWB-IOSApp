//
//  FootRecord.swift
//  Foot_Print
//
//  Created by jingyaoTang on 2019/1/19.
//  Copyright © 2019 jingyaoTang. All rights reserved.
//

import UIKit

struct Record{
    
    let hourmin: String
    let datel: String
    let place:  String
    let content:String
    let photo: UIImage
    //inner info
    
    init(hourmin :String, datel: String, place: String, content: String, photo:  UIImage){
        self.hourmin = hourmin
        self.datel = datel
        self.place = place
        self.content = content
        self.photo = photo
    }
    
    static func recordsFromBundle() -> [Record]{
        
        var records = [Record]()
        
        guard let url = Bundle.main.url(forResource: "records", withExtension: "json") else {
            return records
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]  else {
                return records
            }
            guard let recordObjects = rootObject["records"] as? [[String: AnyObject]] else {
                return records
            }
            
            for recordObject in recordObjects{
                
                if let hourmin = recordObject["hourmin"] as? String,
                    let datel = recordObject["date"] as? String,
                    let place = recordObject["place"] as? String,
                    let content = recordObject["content"] as? String,
                    let photoName = recordObject["photoName"] as? String,
                    let photo = UIImage(named: photoName){
                    
                    let record = Record(hourmin: hourmin, datel: datel, place: place, content: content, photo: photo)
                    records.append(record)
                    
                }
            }
            
        } catch {
            return records
        }
        
        return records
        
    }
    
}
