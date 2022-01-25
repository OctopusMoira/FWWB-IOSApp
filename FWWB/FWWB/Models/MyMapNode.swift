//
//  MyMapNode.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/2/28.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit
import CoreLocation

struct MyMapNode{
    // 坐标
    var location : CLLocation
    // 时间
    var time : Date
    
    init(location:CLLocation,time:Date) {
        self.location = location
        self.time = time
    }
}
