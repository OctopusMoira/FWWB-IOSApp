//
//  TipsTitleCell.swift
//  FWWB
//
//  Created by ZQ on 2019/3/19.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit

class TipsTitleCell : UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    var  tip_htmlstring:String?
    public func setCell(tipsInfo: TipsInfo){
        tip_htmlstring = tipsInfo.url
        //375 667
        self.backgroundColor = cDakaHeavy
        title.text = tipsInfo.title
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        print("tip reuse")
    }
}
