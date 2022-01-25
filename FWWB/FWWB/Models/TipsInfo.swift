//
//  TipsInfo.swift
//  FWWB
//
//  Created by ZQ on 2019/3/19.
//  Copyright © 2019年 fwwb. All rights reserved.
//


import UIKit

class TipsInfo{
    let title: String
    let url: String
    
    init(title: String, url: String){
        self.title = title
        self.url = url
    }
    
    init(info: Dictionary<String,Any>) {
        // TODO
        title  = info["title"] as! String
        url    = info["url"] as! String
    }
}
