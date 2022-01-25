//
//  TipsVC.swift
//  FWWB
//
//  Created by ZQ on 2019/3/19.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit

class TipsVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    var tipsInfo: [TipsInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theBackView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: UIScreen.main.bounds.height-20))
        theBackView.backgroundColor = cTabbarButtonSel
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(self.naviBack))
        swipeBack.delegate = self
        theBackView.addGestureRecognizer(swipeBack)
        self.view.addSubview(theBackView)
        
        tableView.bounds = CGRect(x: 10, y: 20, width: UIScreen.main.bounds.width-20, height: 100*8)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = cDakaHeavy
        
        readTips()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //refresh
    }
    
    @objc func naviBack(_sender: UISwipeGestureRecognizer){
        print("tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TipsVC{
    
    func readTips(){
        let tipAPI = ArticleAPI()
        print("read tips....")
        tipsInfo = tipAPI.getAllTips(url: tipAPI.tips_url)
        }
}

extension TipsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tipsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{            let cell : TipsTitleCell = tableView.dequeueReusableCell(withIdentifier: "TipsTitleCell") as! TipsTitleCell
        cell.setCell(tipsInfo: tipsInfo[indexPath.row])
        return cell
    }
}

extension TipsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let htmlString = tipsInfo[indexPath.row].url
        //print(htmlString,1)
        self.performSegue(withIdentifier: "ShowTipsDetail", sender: htmlString)
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTipsDetail"{
            let controller = segue.destination as! Article
            controller.htmlstring = sender as? String
            print("wo")
            //print(controller.htmlstring)
        }
    }}

