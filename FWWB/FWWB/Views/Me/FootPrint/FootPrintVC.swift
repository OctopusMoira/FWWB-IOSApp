//
//  FootPrintVC.swift
//  FWWB
//
//  Created by ZQ on 2019/3/18.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit

class FootPrintVC: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate{ //!!!
    
    @IBOutlet weak var flag_image: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var records:[Record] = [Record]()
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: .none, queue: OperationQueue.main) { [weak self] _ in
            self?.tableView.reloadData()
            self?.tableView.rowHeight = 200
            self?.tableView.estimatedRowHeight = 180;
            self?.titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
        }
        //获取数据
        let footAPIrecognizer = FootAPI()
        var foot_url:String = footAPIrecognizer.footGet_url+"我的毕业旅行"+"?session_id="+user_id!
       // foot_url = foot_url.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        foot_url = "http://fwwb.0x7cc.com/api/footprints/%E6%88%91%E7%9A%84%E6%AF%95%E4%B8%9A%E6%97%85%E8%A1%8C?session_id=5c95f18c12f33a4592907245"
        print(foot_url)
        let footrecords:footResults = footAPIrecognizer.recognizeLogin(url: foot_url)!
        self.titleLabel.text = footrecords.headname
        for foot in footrecords.footNodes{
            let imageData = Data(base64Encoded: foot.image!)
            let record = Record(hourmin: foot.time ?? "time", datel: foot.date ?? "date", place: foot.location ?? "place", content: foot.comment ?? "content", photo: UIImage(data: imageData!)!)
            self.records.append(record)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeFootPrint))
        self.flag_image.addGestureRecognizer(tapGesture)
        self.flag_image.isUserInteractionEnabled = true
        
        let theBackView = UIView(frame: CGRect(x: 0, y: 20, width: 10, height: UIScreen.main.bounds.height-20))
        theBackView.backgroundColor = cTabbarButtonSel
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(self.naviBack))
        swipeBack.delegate = self
        theBackView.addGestureRecognizer(swipeBack)
        self.view.addSubview(theBackView)
        
    }
    
    @objc func naviBack(_sender: UISwipeGestureRecognizer){
        print("tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeFootPrint(){
        print("FontPrintMap")
        let mapview = UIStoryboard(name: "FootPrintMap", bundle: nil).instantiateViewController(withIdentifier: "footprintmap")
        self.present(mapview, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if let destination = segue.destination as? FootController,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedRecord = records[indexPath.row]
        }
        
    }
}

extension FootPrintVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 == 0){
            let identifier = "UPCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UPViewCell
            let record = records[indexPath.row]
            
            cell.sight1Image.image = record.photo
            cell.hour_min1Label.text = record.hourmin
            cell.date1Label.text=record.datel
            cell.name1Label.text = record.place
            cell.name1Label.font = UIFont.boldSystemFont(ofSize: 16)
            cell.record1Label.text = record.content
            cell.record1Label.frame=CGRect(x: 0, y: 0, width: 80, height: CGFloat.greatestFiniteMagnitude)
            cell.record1Label.numberOfLines = 0
            cell.record1Label.sizeToFit()
            cell.record1Label.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.record1Label.font = UIFont.systemFont(ofSize: 14)
            cell.selectionStyle = .none
            return cell
            
        } else {
            let identifier = "DownCell"
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DownViewCell
            let record = records[indexPath.row]
            
            cell.sight2Image.image = record.photo
            cell.hour_min2Label.text = record.hourmin
            cell.date2Label.text=record.datel
            cell.name2Label.text = record.place
            cell.name2Label.font = UIFont.boldSystemFont(ofSize: 16)
            cell.record2Label.text = record.content
            cell.record2Label.frame=CGRect(x: 0, y: 0, width: 80, height: CGFloat.greatestFiniteMagnitude)
            cell.record2Label.numberOfLines = 0
            cell.record2Label.sizeToFit()
            cell.record2Label.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.record2Label.font = UIFont.systemFont(ofSize: 14)
            cell.selectionStyle = .none
            return cell
            
        }
        
    }
    
}

