//
//  SearchVC.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/3/7.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit
import CoreLocation
import SafariServices

class SearchVC : UIViewController{
    let distinguished = 0
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resulttable: UITableView!
    
    
    let searchUrl = "https://www.baidu.com/s?wd="
    var dTag = 0
    
    let iThisViewCell: String = "ThisViewCell"
    let iNearbyCell : String = "NearbyCell"
    let iTrailCell : String = "TrailCell"
    
    var current: String = ""
    var resultGroup : [[Any]] = []
    var resultCell : [String] = []
    var searchKey : Dictionary<Int,String> = [:]
    
    let searchAPI: BaiduAPI = BaiduAPI()
    
    let locationManager : CLLocationManager = CLLocationManager()
    var currLocation : CLLocation? = nil
    
    /*var locationString : String{
        set{
            searchBar.placeholder = locationString
        }
        get{
            return self.locationString
        }
    }*/
    
    var locationString : String = ""{
        didSet{
            searchBar.placeholder = locationString
        }
    }
    
    var viewOk :Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blankTap))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
        
        self.view.backgroundColor = UIColor.white
        resulttable.dataSource = self
        
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
        let searchKey : String = searchBar.text!
        if(searchKey == current){ return}
        viewOk = 0
        current = searchKey
        resultGroup = []
        resultCell = []
        for i in 0..<3 {
            let titem = searchAPI.getQueryResult(query: searchKey, tag: BaiduAPI.Tag(rawValue: i)!, region: searchKey)
            if titem != nil{
                resultGroup.append(titem!)
                switch i {
                case 0:
                    resultCell.append("附近景点")
                    viewOk = 1
                case 1:
                    resultCell.append("附近餐厅")
                case 2:
                    resultCell.append("附近酒店")
                default:
                    resultCell.append("nil")
                }
            }
        }
        resulttable.reloadData()
    }
    
}

extension SearchVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultCell.count + viewOk
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewOk == 1 && indexPath.row == 0{
            let cell : ThisViewCell = resulttable.dequeueReusableCell(withIdentifier: iThisViewCell) as! ThisViewCell
            cell.imagev.image = UIImage(named: "noImage")
            return cell
        }
        let cell : NearbyCell = resulttable.dequeueReusableCell(withIdentifier: iNearbyCell) as! NearbyCell
        cell.setData(data: resultGroup[indexPath.row - viewOk],loc: currLocation!)
        cell.setCatagory(data: resultCell[indexPath.row - viewOk])
        let buttons = [cell.imageL,cell.imageM,cell.imageR]
        let names = [cell.nameL,cell.nameM,cell.nameR]
        
        for i in 0..<3 {
            buttons[i]?.addTarget(self, action: #selector(buttonAction), for: .touchDown)
            dTag = dTag + 1
            buttons[i]?.tag = dTag
            searchKey[dTag] = names[i]?.text
        }
        return cell
        
    }
    
    
    @objc func buttonAction(btn: UIButton){
        let fullUrl = searchUrl + searchKey[btn.tag]!
        let rawUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let safari : SFSafariViewController = SFSafariViewController(url: URL(string: rawUrl!)!)
        self.present(safari, animated: true, completion: nil)
    }
    
}


extension SearchVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation : CLLocation = locations.last!
        currLocation = lastLocation
        let geoCoder : CLGeocoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(currLocation!, completionHandler: {(placemarks, error)->Void in
            if error != nil{
                print(error as Any)
            }
            let placemark = placemarks?[0]
            print(placemark as Any)
            self.locationString = (placemark?.name)!
        })
        
    }
}

extension SearchVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(current == searchBar.text){
            return
        }
        blankTap()
    }
}
