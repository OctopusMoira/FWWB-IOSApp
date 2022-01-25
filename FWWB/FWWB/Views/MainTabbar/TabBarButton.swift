//
//  TarBarButton.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/1/28.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

/*TabBar中的普通按钮🔘*/
class TabBarButton : UIButton{
    
    fileprivate let fontsize : CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect,title: String,titleImg: String) {
        super.init(frame: frame)
        setImage(UIImage.init(named: titleImg), for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(cTabbarButtonTitle, for: .normal)
        tintColor = cTabbarButton
        
        // 设定按钮图片和标题
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontsize)
        guard
            let imageSize = self.imageView?.frame.size,
            let titleSize = self.titleLabel?.frame.size else{ return }
        let padding : CGFloat = 3.0
        self.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height-padding, left: 0.0, bottom: 0.0, right: -titleSize.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -imageSize.width-padding, right: 0.0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var isSelected: Bool{
        didSet{
            if(isSelected){
                //self.tintColor = cTabbarButtonSel
            }else{
                
                //self.tintColor = cTabbarButton
            }
        }
    }
}
