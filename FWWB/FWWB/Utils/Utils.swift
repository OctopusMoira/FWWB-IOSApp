//
//  Utils.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/1/29.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

class Utils{
    static public func readjson(path: String) -> Any?{
        if let path = Bundle.main.path(forResource: path, ofType: "json"){
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return jsonObj
            }catch{
                print("error : read json failed")
            }
        }
        return nil
    }
    
    // 压缩图片大小
    static private func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage?.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // 编码图片为base64
    static public func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        
        // 压缩图片大小
        if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    static public func base64DecodeImage(_ data: String) -> UIImage{
        let dataDecoded:NSData = NSData(base64Encoded: data, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
    
}
