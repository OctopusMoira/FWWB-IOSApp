//
//  TransMessageItem.swift
//  FWWB
//
//  Created by ZQ on 2019/3/10.
//  Copyright © 2019年 ZQ. All rights reserved.
//

import UIKit

//消息类型，我的还是别人的
enum ChatType {
    case mine
    case someone
}

class TransMessageItem {
    //用户信息
    var user:TransUserInfo
    //消息时间
    var date:Date
    //消息类型
    var mtype:ChatType
    //内容视图，标签或者图片
    var view:UIView
    //边距
    var insets:UIEdgeInsets
    
    //设置我的文本消息边距
    class func getTextInsetsMine() -> UIEdgeInsets {
        return UIEdgeInsets(top:8, left:-5, bottom:9, right:30)
    }
    
    //设置他人的文本消息边距
    class func getTextInsetsSomeone() -> UIEdgeInsets {
        return UIEdgeInsets(top:8, left:30, bottom:9, right:-5)
    }
    
    //构造文本消息体
    convenience init(body:NSString, user:TransUserInfo, date:Date, mtype:ChatType) {
        let font =  UIFont.systemFont(ofSize: 13, weight: .regular)
        
        let width =  225, height = 10000.0
        
        let atts =  [NSAttributedString.Key.font: font]
        
        let size =  body.boundingRect(with:
            CGSize(width: CGFloat(width), height: CGFloat(height)),
            options: .usesLineFragmentOrigin, attributes:atts, context:nil)
        
        let label =  UILabel(frame:CGRect(x: 0, y: 0, width: size.size.width,
                                          height: size.size.height))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = (body.length != 0 ? body as String : "")
        label.font = font
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        
        let insets:UIEdgeInsets =  (mtype == ChatType.mine ?
            TransMessageItem.getTextInsetsMine() : TransMessageItem.getTextInsetsSomeone())
        
        self.init(user:user, date:date, mtype:mtype, view:label, insets:insets)
    }
    
    //可以传入更多的自定义视图
    init(user:TransUserInfo, date:Date, mtype:ChatType, view:UIView, insets:UIEdgeInsets) {
        self.view = view
        self.user = user
        self.date = date
        self.mtype = mtype
        self.insets = insets
    }
    
}
