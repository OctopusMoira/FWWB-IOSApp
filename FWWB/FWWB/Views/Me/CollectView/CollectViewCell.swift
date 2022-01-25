//
//  CollectViewVC.swift
//  FWWB
//
//  Created by ZQ on 2019/3/18.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit

class CollectViewCell: UITableViewCell {
    
    @IBOutlet weak var Artimage: UIImageView!
    @IBOutlet weak var Artitle: UILabel!
    @IBOutlet weak var Artuthor: UILabel!
    var html:String!
    public func setCell(articleInfo: ArticleInfo){
        
        Artimage.image = articleInfo.img
        html = articleInfo.content
        Artitle.text = articleInfo.title
        Artitle.font = UIFont.boldSystemFont(ofSize: 20)
        
        Artuthor.text = "by"+articleInfo.author
        Artuthor.textColor = cArticleAuthorLabel
        Artuthor.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    override func prepareForReuse() {
        print("article reuse")
    }
    
}
