//
//  IndexHeadCell.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/1/29.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

// 顶部轮播图
class IndexHeadCell : UITableViewCell{
    
    
    var tipsOrDaka: UIImageView = UIImageView(frame: CGRect(x: 18, y: UIScreen.main.bounds.width*224/375+18, width: UIScreen.main.bounds.width-18*2, height: (UIScreen.main.bounds.width-18*2)*45/343))
    
    
    public func setCell(headinfo: [HeadInfo]){
        
        tipsOrDaka.image = UIImage(named: "tipsOrDaka")
        
        
        self.contentView.addSubview(tipsOrDaka)
        
        
    }
    
    override func prepareForReuse() {
        print("index reuse")
    }
}
