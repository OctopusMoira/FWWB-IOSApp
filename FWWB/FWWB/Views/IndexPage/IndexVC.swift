//
//  IndexpageVC.swift
//  FWWB
//
//  Created by 叶正茂 on 2019/1/29.
//  Copyright © 2019 fwwb. All rights reserved.
//

import UIKit

class IndexVC : UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var tableView: UITableView!

    var imageSlider: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*224/375))
    
    var articleInfos : [ArticleInfo] = []
    var headInfos : [HeadInfo] = []
    
    var iwidth : CGFloat = 0.0
    var iheight : CGFloat = 0.0
    var icnt : Int = 0
    var timer : Timer? = nil
    var curIndex: Int = 1
    let iHeadCell: String = "IndexHeadCell"
    let iArticleInfoCell : String = "IndexArticleCell"
    func contentClick(uiTap:UITapGestureRecognizer){
    }     //添加监听页面切换的方法
    var tips: UIView = UIView(frame: CGRect(x: 18, y: UIScreen.main.bounds.width*224/375+18, width: (UIScreen.main.bounds.width-18*2)/2, height: (UIScreen.main.bounds.width-18*2)*45/343))
    var daka: UIView = UIView(frame: CGRect(x: 18+(UIScreen.main.bounds.width-18*2)/2, y: UIScreen.main.bounds.width*224/375+18, width: (UIScreen.main.bounds.width-18*2)/2, height: (UIScreen.main.bounds.width-18*2)*45/343))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readArticles()
        readHeads()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        imageSlider.showsVerticalScrollIndicator = false
        imageSlider.showsHorizontalScrollIndicator = false
        imageSlider.isPagingEnabled = true
        imageSlider.delegate = self
        // BUG : 手动适配宽度
        iwidth = imageSlider.frame.width// + 39
        iheight = imageSlider.frame.height
        icnt = headInfos.count
        imageSlider.contentSize = CGSize(width: iwidth*CGFloat(icnt+2), height: iheight)
        
        for i in 0..<icnt{
            let vimg : UIImageView = UIImageView(image: headInfos[i].img)
            vimg.frame = CGRect(x: CGFloat(i+1)*iwidth, y: 0, width: iwidth, height: iheight)
            imageSlider.addSubview(vimg)
        }
        //let llimageData = Data(base64Encoded: headInfos[icnt-1].img)
        //let rlimageData = Data(base64Encoded: headInfos[0].img)
        //articleImg.image = UIImage(data: imageData!)        // 添加左右
        let limg : UIImageView = UIImageView(image: headInfos[icnt-1].img)
        limg.frame = CGRect(x: 0, y: 0, width: iwidth, height: iheight)
        let rimg : UIImageView = UIImageView(image: headInfos[0].img)
        rimg.frame = CGRect(x: CGFloat(icnt+1)*iwidth, y: 0, width: iwidth, height: iheight)
        imageSlider.addSubview(limg)
        imageSlider.addSubview(rimg)
        // N 0 1 2 .. N 0 设定在第一张图片
        imageSlider.contentOffset = CGPoint(x: iwidth, y: 0)
        startTimer()
        
        let clickTips = UITapGestureRecognizer(target: self, action: #selector(self.click1))
        clickTips.delegate = self
        tips.addGestureRecognizer(clickTips)
        
        let clickDaka = UITapGestureRecognizer(target: self, action: #selector(self.click2))
        clickDaka.delegate = self
        daka.addGestureRecognizer(clickDaka)
        
        tips.alpha = 1.0
        daka.alpha = 1.0
        
        let click = UITapGestureRecognizer(target:self,action:  #selector(clickroll(slider:)))
        click.delegate = self
        imageSlider.addGestureRecognizer(click)
        
        self.view.addSubview(imageSlider)
        tableView.addSubview(tips)
        tableView.addSubview(daka)
        
    }
    @objc func clickroll(slider: UIScrollView){
        //let num: Int = Int(slider.contentOffset.x/slider.frame.size.width)
        
        let pageWidth: CGFloat = self.imageSlider.frame.size.width;
        var page: Int = Int(floor((self.imageSlider.contentOffset.x - pageWidth / 2) / pageWidth));
        page = (page)%4
        print(page)
        self.performSegue(withIdentifier: "RollShowArticledetail", sender: headInfos[ page].url)
        
    }
    @objc func click1(){
        print("print tips")
        let sb = UIStoryboard(name: "Tips", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TipsVC") as! TipsVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func click2(){
        print("print daka")
        let sb = UIStoryboard(name: "Daka", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DakaVC") as! DakaVC
        self.present(vc, animated: true, completion: nil)
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

extension IndexVC{
    // 加载文章
    func readArticles(){
        print("read articles   it...")
        let api = ArticleAPI()
        
        articleInfos=api.getAllArticles(url: api.recognize_url + "?session_id=" + user_id!)
        print("read ok...")
        
        print(articleInfos.count)
    }
    // 加载头部轮播图片
    func readHeads(){
        //guard let jsonObj = Utils.readjson(path: "heads") as? Dictionary<String, Any>,
        //let heads = jsonObj["heads"] as? Array<Dictionary<String,Any>> else{return}
        let headRecognizer = ArticleAPI()
        let headArticles:[ArticleInfo] =  headRecognizer.getAllArticles(url: headRecognizer.roll_url)
        for headArticle in headArticles{
            let head = HeadInfo(
                img: headArticle.img!,
                url: headArticle.content
            )
            headInfos.append(head)
        }
    }
}


extension IndexVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return articleInfos.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            let cell : IndexHeadCell = tableView.dequeueReusableCell(withIdentifier: iHeadCell) as! IndexHeadCell
            cell.setCell(headinfo: headInfos)
            
            return cell
        default:
            let cell : IndexArticleCell = tableView.dequeueReusableCell(withIdentifier: iArticleInfoCell) as! IndexArticleCell
            cell.setCell(articleInfo: articleInfos[indexPath.row-1])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        switch indexPath.row {
        case 0: return false
        default: return true
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "收藏"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let paramdict:NSMutableDictionary = ["session_id":user_id!,"article_id":articleInfos[indexPath.row-1].id as Any]
            //post
            let collectAPI = LoginAPI()
            collectAPI.recognizeLogin(url:collectAPI.collect_url ,data: paramdict)
            print("post like \(indexPath)")
        }
    }
    
}
extension IndexVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.row {
        case 0:
            return UIScreen.main.bounds.width*224/375+18+(UIScreen.main.bounds.width-18*2)*45/343+5
        default:
            return 150
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let htmlString = articleInfos[indexPath.row-1].content
        
        self.performSegue(withIdentifier: "ShowArticledetail", sender: htmlString)
    }
    
    //在这个方法中给新页面传递参数
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticledetail"{
            let controller = segue.destination as! Article
            controller.htmlstring = sender as? String
        }
        else if segue.identifier == "RollShowArticledetail"{
            let controller = segue.destination as! Article
            controller.htmlstring = sender as? String
        }
    }
}



extension IndexVC: UIScrollViewDelegate{
    func scrollMethod(){
        if imageSlider.contentOffset.x <= 0{
            imageSlider.contentOffset = CGPoint(x: iwidth*CGFloat(icnt),y: 0)
            
        }else if imageSlider.contentOffset.x >= CGFloat(icnt+1)*iwidth{
            imageSlider.contentOffset = CGPoint(x: iwidth,y: 0)
        }
        //curIndex = Int((imageSlider.contentOffset.x / iwidth))%4
        
    }
    // 结束滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollMethod()
        startTimer()
        //curIndex = Int((imageSlider.contentOffset.x / iwidth-1))%4
        
    }
    
    // 调试拽动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
        scrollMethod()
        //curIndex = Int((imageSlider.contentOffset.x / iwidth-1))%4
        
    }
    
    // 开始滚动
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        stopTimer()
        scrollMethod()
        // curIndex = Int((imageSlider.contentOffset.x / iwidth-1))%4
        
    }
    
    func startTimer(){
        if((self.timer) != nil) {return}
        self.timer = Timer(timeInterval: 4.0, target: self, selector: #selector(timerHandle), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: .default)
        //curIndex = Int((imageSlider.contentOffset.x / iwidth-1))%4
        
    }
    
    func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
        //curIndex = Int((imageSlider.contentOffset.x / iwidth-1))%4
        
    }
    
    @objc func timerHandle(){
        let pos = imageSlider.contentOffset.x / iwidth + 1
        //print(pos,"timer")
        curIndex = Int((imageSlider.contentOffset.x / iwidth-1))%4
        imageSlider.setContentOffset(CGPoint(x: pos*iwidth, y: 0), animated: true)
        scrollMethod()
    }
    
    
}
