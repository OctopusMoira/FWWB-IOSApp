//
//  DakaVC.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/10.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit
import CoreLocation

class DakaVC : UIViewController, UIGestureRecognizerDelegate{
    
    //375 667
    let exitFrame = CGRect(x: UIScreen.main.bounds.width*0.1, y: UIScreen.main.bounds.height*0.876,width: UIScreen.main.bounds.width*0.237, height: UIScreen.main.bounds.height*0.054)
    let submitFrame = CGRect(x: UIScreen.main.bounds.width*0.663, y: UIScreen.main.bounds.height*0.876, width: UIScreen.main.bounds.width*0.237, height: UIScreen.main.bounds.height*0.054)
    let currentFP = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.1227, y: UIScreen.main.bounds.height*0.073,width: UIScreen.main.bounds.width*0.8, height: 30))
    let currentLC = UILabel(frame: CGRect(x: UIScreen.main.bounds.width*0.1227, y: UIScreen.main.bounds.height*0.809-30,width: UIScreen.main.bounds.width*0.8, height: 30))
    var node:Dictionary = ["location":"","date":"","comment":"","longitude":0,"latitude":0] as [String : Any]
    //var paradim:Dictionary = ["footprint_name":"","new_node":node]
    let locationManager : CLLocationManager = CLLocationManager()
    var currentFPname: String = "我的毕业足迹"
    //var currentLCtion: String = "需要GPS定位"
    var currLocation : CLLocation? = nil
    /*var placemark : CLPlacemark = CLPlacemark(){
     didSet{
     //currentLCtion = placemark.name!
     //currentLC.text = "当前定位  " + placemark.name!
     }
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGround = DakaCanvas(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(backGround)
        
        //current footprint
        currentFP.font = UIFont.boldSystemFont(ofSize: 20)
        currentFP.textColor = UIColor.white
        currentFP.text = "当前足迹  "+currentFPname
        self.view.addSubview(currentFP)
        
        //current location
        currentLC.font = UIFont.boldSystemFont(ofSize: 20)  //0.625
        currentLC.textColor = cDakaHeavy
        currentLC.text = "当前定位  "
        self.view.addSubview(currentLC)
        
        //textfield
        let myRecord = UITextView(frame: CGRect(x: UIScreen.main.bounds.width*0.15, y: UIScreen.main.bounds.height*0.17, width: UIScreen.main.bounds.width*0.7, height: UIScreen.main.bounds.height*0.35))
        myRecord.backgroundColor = sectionsLight
        myRecord.font = UIFont.boldSystemFont(ofSize: 16)
        myRecord.textColor = cBubbleColorHeavy
        self.view.addSubview(myRecord)
        
        let exit_T = UILabel(frame: exitFrame)
        let submit_T = UILabel(frame: submitFrame)
        //exit button
        exit_T.text = "退出"
        exit_T.textAlignment = .center
        exit_T.textColor = cBubbleColorLight
        exit_T.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(exit_T)
        //submit button
        submit_T.text = "添加"
        submit_T.textAlignment = .center
        submit_T.textColor = UIColor.black
        submit_T.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(submit_T)
        
        let exitTouch = UIView(frame: exitFrame)
        let clickExit = UITapGestureRecognizer(target: self, action: #selector(self.returnIndex))
        clickExit.delegate = self
        exitTouch.addGestureRecognizer(clickExit)
        let submitTouch = UIView(frame: submitFrame)
        let clickSubmit = UITapGestureRecognizer(target: self, action: #selector(self.publishRecord))
        clickSubmit.delegate = self
        submitTouch.addGestureRecognizer(clickSubmit)
        self.view.addSubview(exitTouch)
        self.view.addSubview(submitTouch)
        
        let blank = UITapGestureRecognizer(target: self, action: #selector(self.blankTap))
        self.view.addGestureRecognizer(blank)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 500
        locationManager.requestAlwaysAuthorization()
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            print("定位")
        }
        
    }
    
    @objc func blankTap(){
        UIApplication.shared.keyWindow?.endEditing(true)
        
    }
    func textFieldShouldEndediting(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        //打印出文本框中的值
        node["recordText"] = textField.text
        return true;
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func returnIndex(){
        print("tap exit")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func publishRecord(){
        print("tap publish")
        self.dismiss(animated: true, completion: nil)
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd HH:mm:ss"
        let stringTime = dateFormatter.string(from: now)
        node["date"] = stringTime.components(separatedBy: " ")[0]
        node["time"] = stringTime.components(separatedBy: " ")[1]
        let paradim:Dictionary = ["footprint_name":currentFPname,"new_node":node] as [String : Any]
        //PUT
        let footPutAPI = FootAPI();
        let post_url:String = footPutAPI.footGet_url+"?session_id="+user_id!
        
        footPutAPI.FootPostCall(rawurl: post_url, params: paradim as NSDictionary)
    }
    
}

extension DakaVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation : CLLocation = locations.last!
        currLocation = lastLocation
        let geoCoder : CLGeocoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(currLocation!, completionHandler: {(placemarks, error)->Void in
            if error != nil{
                print(error as Any)
            }
            //获取经纬度
            self.node["latitude"] = self.currLocation?.coordinate.latitude
            self.node["longtitude"] = self.currLocation?.coordinate.longitude
            let placemark = (placemarks?[0])!
            self.node["location"] = placemark.name //获取地理名
            print(placemark)
            self.currentLC.text = "当前定位  " + placemark.name!
        }
        )
        
    }
}

class DakaCanvas: UIView {
    
    let exitFrame = CGRect(x: UIScreen.main.bounds.width*0.1, y: UIScreen.main.bounds.height*0.876,width: UIScreen.main.bounds.width*0.237, height: UIScreen.main.bounds.height*0.054)
    let submitFrame = CGRect(x: UIScreen.main.bounds.width*0.663, y: UIScreen.main.bounds.height*0.876, width: UIScreen.main.bounds.width*0.237, height: UIScreen.main.bounds.height*0.054)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = cDakaHeavy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        //375 667
        //cardMain
        let card = CGRect(x: UIScreen.main.bounds.width*0.1, y: UIScreen.main.bounds.height*0.12, width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.height*0.736)
        let cardMain = UIBezierPath(roundedRect: card, cornerRadius: 6)
        
        //exit button
        let exitMain = UIBezierPath(roundedRect: exitFrame, cornerRadius: 6)
        
        //submit button
        let submitMain = UIBezierPath(roundedRect: submitFrame, cornerRadius: 6)
        
        //shadow
        context!.saveGState()
        
        let shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        let shadowOffset = CGSize(width: 3, height: 3)
        let shadowBlurRadius:CGFloat = 5.0
        
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadowColor)
        sectionsLight.setFill()
        cardMain.fill()
        exitMain.fill(with: .normal, alpha: 0.32)
        cBubbleColorHeavy.setFill()
        submitMain.fill()
        context!.restoreGState()
        
    }
    
}
