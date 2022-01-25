//
//  TransTableViewCell.swift
//  FWWB
//
//  Created by ZQ on 2019/3/10.
//  Copyright © 2019年 ZQ. All rights reserved.
//

import UIKit

class TransTableViewCell:UITableViewCell {
    //消息内容视图
    var customView:UIView!
    //消息背景
    var bubbleImage:UIImageView!
    //消息数据结构
    var msgItem:TransMessageItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //- (void) setupInternalData
    init(data:TransMessageItem, reuseIdentifier cellId:String) {
        self.msgItem = data
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier:cellId)
        rebuildUserInterface()
    }
    
    func rebuildUserInterface() {
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        if (self.bubbleImage == nil)
        {
            self.bubbleImage = UIImageView()
            self.addSubview(self.bubbleImage)
        }
        
        let type =  self.msgItem.mtype
        let width =  self.msgItem.view.frame.size.width
        let height =  self.msgItem.view.frame.size.height
        
        var x =  (type == ChatType.someone) ? 0 : self.frame.size.width - width -
            self.msgItem.insets.left - self.msgItem.insets.right
        
        let y:CGFloat =  0
        
        self.customView = self.msgItem.view
        self.customView.frame = CGRect(x: x + self.msgItem.insets.left,
                                       y: y + self.msgItem.insets.top, width: width, height: height)
        
        self.addSubview(self.customView)
        
        //如果是别人的消息，在左边，如果是我输入的消息，在右边
        if (type == ChatType.someone)
        {
            self.bubbleImage.image = UIImage(named:("yoububble.png"))!
                .stretchableImage(withLeftCapWidth: 21,topCapHeight:0)//.stretchableImage(withLeftCapWidth: 21,topCapHeight:25)
            
        }
        else {
            self.bubbleImage.image = UIImage(named:"mebubble.png")!
                .stretchableImage(withLeftCapWidth: 15,topCapHeight:0)//.stretchableImage(withLeftCapWidth: 15, topCapHeight:25)
        }
        if (type == ChatType.someone){
            x += 20
        }
        if (type == ChatType.mine){
            x -= 20
        }
        self.bubbleImage.frame = CGRect(x: x, y: y,
                                        width: width + self.msgItem.insets.left + self.msgItem.insets.right, height: height + self.msgItem.insets.top + self.msgItem.insets.bottom)
        
    }
    
    //让单元格宽度始终为屏幕宽
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = UIScreen.main.bounds.width
            super.frame = frame
        }
    }
}
