//
//  LoginResult.swift
//  Login
//
//  Created by jingyaoTang on 2019/3/19.
//  Copyright © 2019 jingyaoTang. All rights reserved.
//

import Foundation
var user_id:String?
struct Rec_Result{
   var result: String?
   var image: String?
   var recognization_id: String?
   var timestamp: String?
}
struct Rec_Response:Codable{
    var result: String?
    var image: String?
    var recognization_id: String?
    var timestamp: String?
    
}
struct Textresponse: Codable{
    var session_id: String?
}
struct ArticleResult{
    var article_id: String?
    var tag: String?
    var title: String?
    var auther: String?
    var content: String?
    var cover:String?
    var is_rolling:Bool?
    var save:Bool?
    
}
struct Articleresponses:Codable{
    var articles: [Articleresponse]
}
struct Articleresponse: Codable{
    var article_id: String?
    var tag: String?
    var title: String?
    var auther: String?
    var content: String?
    var cover:String?
    var is_rolling:Bool?
    var save:Bool?
}

struct footResults{
    var  headname:String?
    var  footNodes:[footResult]
}
struct footResult {
    var  location:String?
    var  date: String?
    var   time: String?
    var     comment: String?
    var    longitude: Double?
    var     latitude: Double?
    // 创建的时候不带这个字段也可以
    var  image: String?
}
struct Footresponses:Codable{
    var name:String?
    var nodes:[Footresponse]
}
struct Footresponse: Codable{
    var  location:String?
    var  date: String?
    var   time: String?
    var     comment: String?
    var    longitude: Double?
    var     latitude: Double?
    // 创建的时候不带这个字段也可以
    var  image: String?
}
