//
//  RecViewVC.swift
//  FWWB
//
//  Created by ZQ on 2019/3/18.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit
import CoreLocation
import SafariServices

class RecViewVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    var recSaved: [RecSaved] = []
    let searchUrl = "https://www.baidu.com/s?wd="
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        readRecs()
        
        let theBackView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height:  UIScreen.main.bounds.height-20))
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
    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
        //refresh
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight = tableView.bounds.size.height
        
        // move all cells to the bottom of the screen
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        // move all cells from bottom to the right place
        var index = 0
        for cell in cells {
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            index += 1
        }
    }
    
}

extension RecViewVC{
    // 加载文章
    func readRecs(){
            let api = RecognizationSaveApi()
            let recs = api.get(sessionid: "5c96f49d12f33a66be74658d")
            self.recSaved = recs
            print("got rec")
    }
}


extension RecViewVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return recSaved.count-1//-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell : RecViewCell = tableView.dequeueReusableCell(withIdentifier: "RecViewCell") as! RecViewCell
        cell.setCell(recSaved: recSaved[indexPath.row])
        return cell
    }
}
extension RecViewVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        //switch indexPath.row {
        //case 0:
            //return UIScreen.main.bounds.width*224/375+18+(UIScreen.main.bounds.width-18*2)*45/343+5
        //default:
            return 100
        //}
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let fullUrl = searchUrl + recSaved[indexPath.row].title
        let rawUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let safari : SFSafariViewController = SFSafariViewController(url: URL(string: rawUrl!)!)
        self.present(safari, animated: true, completion: nil)    }
}
