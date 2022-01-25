//
//  NearbyCell.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/7.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class NearbyCell : UITableViewCell{
    
    @IBOutlet weak var catagory: UILabel!
    @IBOutlet weak var more: UILabel!
    
    @IBOutlet weak var imageL: UIButton!
    @IBOutlet weak var imageM: UIButton!
    @IBOutlet weak var imageR: UIButton!
    
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var nameM: UILabel!
    @IBOutlet weak var nameR: UILabel!
    
    @IBOutlet weak var disL: UILabel!
    @IBOutlet weak var disM: UILabel!
    @IBOutlet weak var disR: UILabel!
    
    //let seekAPI: BaiduAPI = BaiduAPI()
    
    public func setData(data: [Any],loc: CLLocation){
        let images: [UIButton] = [imageL,imageM,imageR]
        let names: [UILabel] = [nameL,nameM,nameR]
        let diss: [UILabel] = [disL,disM,disR]
        
        var cnt = 0
        for item in data {
            if cnt >= 3 { break }
            let nitem = item as! [String:Any]
            let loct = nitem["location"] as! [String:Double]
            let distance = CLLocation(latitude: loct["lat"]!, longitude: loct["lng"]!).distance(from: loc)/1000
            if distance >= 100{
                diss[cnt].text = ">100KM"
            }else{
                diss[cnt].text = String(format:"%.2f",distance) + "KM"
            }
            names[cnt].text = nitem["name"] as? String
            images[cnt].setImage(UIImage(named: "noImage.png"), for: .normal)
            /*
             if nitem["street_id"] == nil && loct["lat"] != nil && loct["lng"] != nil {
             images[cnt].setImage(UIImage(named: "noImage.png"), for: .normal)
             } else{
             images[cnt].setImage(UIImage(imageLiteralResourceName: "http://api.map.baidu.com/panorama/v2?ak=\(key))&width=512&height=256&location=\(loct["lat"]),\(loct["lng"])&fov=180 "), for: .normal)
             }
             */
            
            cnt = cnt+1;
        }
    }
    
    public func setCatagory(data: String){
        catagory.text = data
    }
    
    
}
