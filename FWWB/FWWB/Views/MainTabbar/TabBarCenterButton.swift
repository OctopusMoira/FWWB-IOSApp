//
//  TabBarCenterButton.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/1/28.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

class TabBarCenterButton : UIView{
    public let button : UIButton
    fileprivate let img : String = "paishe"
    
    override init(frame: CGRect) {
        let btnPadding : CGFloat = 10.0
        let btnRect = CGRect(
            x: btnPadding, y: btnPadding,
            width: frame.width-btnPadding*2.0, height: frame.height-btnPadding*2.0)
        button = UIButton(frame: btnRect)
        button.setImage(UIImage.init(named: img), for: .normal)
        button.backgroundColor = cTabbarButtonSel//UIColor.white
        button.tintColor = UIColor.darkGray.withAlphaComponent(0.8)
        button.layer.cornerRadius = button.frame.height/2.0
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(
            top: btnPadding, left: btnPadding, bottom: btnPadding, right: btnPadding)
        super.init(frame: frame)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: -2.5)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
