//
//  RecViewCell.swift
//  FWWB
//
//  Created by ZQ on 2019/3/20.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit

class RecViewCell: UITableViewCell {
    
    @IBOutlet weak var recimage: UIImageView!
    @IBOutlet weak var recitle: UILabel!
    @IBOutlet weak var recime: UILabel!
    
    public func setCell(recSaved: RecSaved){
        
        recimage.image =  recSaved.img
        
        recitle.text = recSaved.title
        recitle.font = UIFont.boldSystemFont(ofSize: 20)
        
        recime.text = recSaved.time
        recime.textColor = cArticleAuthorLabel
        recime.font = UIFont.boldSystemFont(ofSize: 14)
        
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        print("article reuse")
    }
    
}
