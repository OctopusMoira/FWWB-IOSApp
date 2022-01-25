//
//  Article.swift
//  mainPage
//
//  Created by ZQ on 2019/1/16.
//  Copyright © 2019年 ZQ. All rights reserved.
//

import UIKit

class ArticleInfo{
    let title: String
    let author:String
    let tag: String
    let img: UIImage?
    let content: String
    let save: Bool
    let id :String
    init(title: String?,  author: String?, tag: String?, img: UIImage?,content: String?,save:Bool?,id:String?){
        self.title = title ?? "title"
        self.author = author ?? "auther"
        self.tag = tag ?? "tag"
        self.img = img
        self.content = content ?? "content"
        self.save = save ?? false
        self.id = id ?? "id"
    }
}
