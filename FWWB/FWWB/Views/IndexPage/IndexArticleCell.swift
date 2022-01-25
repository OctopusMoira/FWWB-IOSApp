//
//  IndexArticleCell.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/1/29.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

class IndexArticleCell : UITableViewCell{
    
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelLabel: UILabel!
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var myHeart: UIImageView!
    
    var html_string:String!
    public func setCell(articleInfo: ArticleInfo){
        html_string = articleInfo.content
        
        if articleInfo.save == false {
            myHeart.image = UIImage(named: "hallowHeart")
        } else {
            myHeart.image = UIImage(named: "fullHeart")
        }
       
        articleImg.image = articleInfo.img
        // 设置信息
        authorLabel.text = "by"+articleInfo.author
        authorLabel.textColor = cArticleAuthorLabel
        authorLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        titleLabel.text = articleInfo.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        labelLabel.text = articleInfo.tag
        //设置uiview的阴影
        articleView.layer.shadowColor=UIColor.black.cgColor
        // 阴影偏移，默认(0, -3)
        articleView.layer.shadowOffset = CGSize(width: 0, height: 0)
        // 阴影透明度，默认0
        articleView.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        articleView.layer.shadowRadius = 5;
        labelLabel.textColor = cTabbarButtonSel
        labelLabel.font = UIFont.boldSystemFont(ofSize: 13)
    }
    
    override func prepareForReuse() {
        print("article reuse")
    }
}

