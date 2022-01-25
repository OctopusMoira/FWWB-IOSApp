//
//  ImageResultVC.swift
//  FWWB
//
//  Created by 叶正茂 on 2018/12/5.
//  Copyright © 2018 fwwb. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class ImageResultVC: UIViewController {
    
    @IBOutlet weak var ads: UIImageView!
    @IBOutlet weak var imageViewL: UIImageView!
    @IBOutlet weak var imageViewR: UIImageView!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var textFieldL: UITextField!
    @IBOutlet weak var textFieldR: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var image:UIImage?
    var results = [[String: Any?]]()
    var currentLeftResultIndex = 0
    
    var searchKey : Dictionary<Int,String> = [:]
    
    var dTag = 0

    override func viewDidAppear(_ animated: Bool) {
        // 显示等待标示
        let alert = UIAlertController(title: nil, message: "Recognizing...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        // 识别地标
        DispatchQueue.main.async{
            let googleRecognizer = GoogleVisionApi()
            let results_img = googleRecognizer.recognizeLandmark(data: self.landmarkRequestData())
            // 文字
            let results_text = googleRecognizer.recognizeText(data: self.textRequestData())
            
            alert.dismiss(animated: false, completion: nil)
            
            if results_img != nil && results_img?.count != 0{
                // 获取照片
                print(results_img![0].imgUrl)
                self.updateResult(results: results_img)
            }else if results_text != nil{
                // 翻译文字
                self.updateResultText(results: results_text!)
            }else{
                let alert = UIAlertController(title: "Error", message: "没有识别结果", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    
    }

    override func viewDidLoad() {
        self.ads.image = UIImage(named: "0")
        self.imageView.image = self.image
        self.textFieldL.isHidden = true
        self.textFieldR.isHidden = true
        self.imageViewL.isHidden = true
        self.imageViewR.isHidden = true
        self.rightArrow.isHidden = true
        self.leftArrow.isHidden = true
    }
    
    private func landmarkRequestData() -> String {
        let image = Image(content: Utils.base64EncodeImage(self.image!))
        let features = [Feature]([Feature(type: .LANDMARK_DETECTION)])
        let requests = Requests(requests: [Request(image: image, features: features)])
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(requests)
        var jsonString = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
        jsonString = jsonString?.replacingOccurrences(of: "\\", with: "")
        return jsonString!
    }
    
    private func textRequestData() -> String{
        let image = Image(content: Utils.base64EncodeImage(self.image!))
        let features = [Feature]([Feature(type: .TEXT_DETECTION)])
        let requests = Requests(requests: [Request(image: image, features: features)])
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(requests)
        var jsonString = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
        jsonString = jsonString?.replacingOccurrences(of: "\\", with: "")
        return jsonString!
    }
    
    private func updateResult(results: Array<ImageRecognizeResult>?) {
        self.textFieldL.isHidden = false
        self.imageViewL.isHidden = false
        self.leftArrow.isHidden = false
        self.rightArrow.isHidden = false
        self.textFieldL.text = results![0].landmark
        self.imageViewL.image = self.imageView.image
        
        dTag = dTag + 1
        self.imageViewL.tag = dTag
        searchKey[dTag] = results![0].landmark
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        self.imageViewL.addGestureRecognizer(tapGesture)
        self.imageViewL.isUserInteractionEnabled = true
        
       // saveHistory(result: results![0].landmark, image: self.imageView.image!)
    }
    
    
    @objc func imageViewClick(sender: UIImageView){
        let fullUrl = "https://www.baidu.com/s?wd=" + searchKey[dTag]!
        let rawUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let safari : SFSafariViewController = SFSafariViewController(url: URL(string: rawUrl!)!)
        self.present(safari, animated: true, completion: nil)
    }
    
    private func updateResultText(results: String){
        self.textFieldL.isHidden = false
        self.imageViewL.isHidden = false
        self.leftArrow.isHidden = false
        self.rightArrow.isHidden = false
        let api = BaiduAPI()
        self.textFieldL.text = api.translate(content: results, nationality: false)
        self.imageViewL.image = self.imageView.image
    }
    
    /* 返回 */
    @IBAction func clickReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* 向左滚动图片 */
    @IBAction func clickLeftArrow(_ sender: UIButton) {
        if self.results.count <= 2 {
            return
        }
        var leftResultIndex = self.currentLeftResultIndex + 1
        var rightResultIndex = self.currentLeftResultIndex + 2
        if leftResultIndex >= self.results.count {
            leftResultIndex = leftResultIndex - self.results.count
        }
        if rightResultIndex >= self.results.count {
            rightResultIndex = rightResultIndex - self.results.count
        }
        self.textFieldL.text = self.results[leftResultIndex]["result"] as? String
        if let imageData = results[leftResultIndex]["data"] as? Data {
            self.imageViewL.image = UIImage(data: imageData)
            self.view.backgroundColor = UIColor(patternImage: self.imageViewL.image!)
        }
        self.textFieldR.text = self.results[rightResultIndex]["result"] as? String
        if let imageData = results[rightResultIndex]["data"] as? Data {
            self.imageViewR.image = UIImage(data: imageData)
        }
        self.currentLeftResultIndex = leftResultIndex
    }
    
    /* 向右滚动图片 */
    @IBAction func clickRightArrow(_ sender: UIButton) {
        if self.results.count <= 2 {
            return
        }
        var leftResultIndex = self.currentLeftResultIndex - 1
        let rightResultIndex = self.currentLeftResultIndex
        if leftResultIndex < 0 {
            leftResultIndex = self.results.count - 1
        }
        self.textFieldL.text = self.results[leftResultIndex]["result"] as? String
        if let imageData = results[leftResultIndex]["data"] as? Data {
            self.imageViewL.image = UIImage(data: imageData)
            self.view.backgroundColor = UIColor(patternImage: self.imageViewL.image!)
        }
        self.textFieldR.text = self.results[rightResultIndex]["result"] as? String
        if let imageData = results[rightResultIndex]["data"] as? Data {
            self.imageViewR.image = UIImage(data: imageData)
        }
        self.currentLeftResultIndex = leftResultIndex
    }
}


extension ImageResultVC{
    /*
    private func saveHistory(result: String,image: UIImage){
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let historyEntity = NSEntityDescription.entity(forEntityName: "ImageResultHistory", in: managedObjectContext)!
        
        let history = NSManagedObject(entity: historyEntity, insertInto: managedObjectContext)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let timeString = formatter.string(from: Date())
        
        history.setValue(result, forKey: "result")
        history.setValue(timeString, forKey: "time")
        history.setValue(Utils.base64EncodeImage(image), forKey: "image")
        print("save it")
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }*/
}
