//
//  CollectViewVC.swift
//  FWWB
//
//  Created by ZQ on 2019/3/20.
//  Copyright © 2019年 fwwb. All rights reserved.
//

import UIKit

class CollectViewVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var articleInfos : [ArticleInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readArticles()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
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
extension CollectViewVC{
    // 加载文章
    func readArticles(){
        //guard let jsonObj = Utils.readjson(path: "articles") as? Dictionary<String, Any>,
        //let articles = jsonObj["articles"] as? Array<Dictionary<String,Any>> else{return}
        //API 处请求收藏的文章
        let ArticleAPIrecognizer = ArticleAPI()
        let collect_url = ArticleAPIrecognizer.recognize_url+"?session_id="+user_id!
        print(collect_url)
        let results : [ArticleInfo] = ArticleAPIrecognizer.getAllArticles(url: collect_url)
        print( results.count)
        for result in results {
            if(result.save ){
                let articleinfo = ArticleInfo(
                    title: result.title ,
                    author: result.author ,
                    tag: result.tag ,
                    img: result.img,
                    content: result.content,
                    save: result.save ,
                    id:result.id
                )
                articleInfos.append(articleinfo)
            }
        }
    }
}


extension CollectViewVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return articleInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell : CollectViewCell = tableView.dequeueReusableCell(withIdentifier: "CollectViewCell") as! CollectViewCell
        cell.setCell(articleInfo: articleInfos[indexPath.row])
        return cell
    }
}
extension CollectViewVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let htmlString = articleInfos[indexPath.row].content
        
        self.performSegue(withIdentifier: "ShowCollectdetail", sender: htmlString)
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCollectdetail"{
            let controller = segue.destination as! Article
            controller.htmlstring = sender as? String
        }
    }
    
}
