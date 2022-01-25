//
//  IndexHeadImgCell.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/2/28.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

class IndexHeadImgCell : UICollectionViewCell{
    
    @IBOutlet weak var headImgView: UIImageView!
    
    public func setCell(path: String){
        print(path)
        headImgView.image = UIImage(named: path)
    }
}
